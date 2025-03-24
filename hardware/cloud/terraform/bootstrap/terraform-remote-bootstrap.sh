#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

log() {
    local level="$1"
    shift
    local timestamp="$(date +"%Y-%m-%d %H:%M:%S")"

    if [[ "$level" == "ERROR" ]]; then
        echo "$timestamp [$level] $*" >&2
    else
        echo "$timestamp [$level] $*"
    fi
}

log_info()  { log "INFO" "$@"; }
log_warn()  { log "WARN" "$@"; }
log_error() { log "ERROR" "$@" >&2; }

trap 'log_error "Script failed"; exit 1' ERR

# Configuration
BUCKET_NAME="${TERRAFORM_BUCKET:-g-mattjmcnaughton-homelab-terraform-state}"
TABLE_NAME="${TERRAFORM_LOCK_TABLE:-g-mattjmcnaughton-homelab-terraform-state-lock}"
REGION="${AWS_REGION:-us-east-1}"

bucket_exists() {
    aws s3api head-bucket --bucket "$BUCKET_NAME" --region "$REGION" 2>/dev/null
    return $?
}

table_exists() {
    aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" &>/dev/null
    return $?
}

create_s3_bucket() {
    log_info "Creating Terraform state bucket '$BUCKET_NAME'..."

    if [[ "$REGION" = "us-east-1" ]]; then
        aws s3api create-bucket \
            --bucket "$BUCKET_NAME" \
            --region "$REGION" \
            --output json
    else
        aws s3api create-bucket \
            --bucket "$BUCKET_NAME" \
            --region "$REGION" \
            --create-bucket-configuration LocationConstraint="$REGION" \
            --output json
    fi

    log_info "Enabling versioning..."
    aws s3api put-bucket-versioning \
        --bucket "$BUCKET_NAME" \
        --versioning-configuration Status=Enabled

    log_info "Enabling encryption..."
    aws s3api put-bucket-encryption \
        --bucket "$BUCKET_NAME" \
        --server-side-encryption-configuration '{
            "Rules": [
                {
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }
            ]
        }'

    log_info "Blocking public access..."
    aws s3api put-public-access-block \
        --bucket "$BUCKET_NAME" \
        --public-access-block-configuration '{
            "BlockPublicAcls": true,
            "IgnorePublicAcls": true,
            "BlockPublicPolicy": true,
            "RestrictPublicBuckets": true
        }'

    log_info "Adding lifecycle rules..."
    aws s3api put-bucket-lifecycle-configuration \
        --bucket "$BUCKET_NAME" \
        --lifecycle-configuration '{
            "Rules": [
                {
                    "ID": "ExpireOldVersions",
                    "Status": "Enabled",
                    "Filter": {},
                    "NoncurrentVersionExpiration": {
                        "NoncurrentDays": 90
                    }
                }
            ]
        }'

    log_info "Terraform state bucket '$BUCKET_NAME' created successfully with secure configuration."
}

create_dynamodb_table() {
    log_info "Creating Terraform state lock table '$TABLE_NAME'..."

    aws dynamodb create-table \
        --table-name "$TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "$REGION" \
        --output json

    log_info "Waiting for DynamoDB table to become active..."
    aws dynamodb wait table-exists \
        --table-name "$TABLE_NAME" \
        --region "$REGION"

    log_info "Terraform state lock table '$TABLE_NAME' created successfully."
}

print_configuration() {
    log_info "TERRAFORM/OPENTOFU BACKEND CONFIGURATION:"
    echo "----------------------------------------"
    echo "Add the following to your Terraform/OpenTofu configuration files:"
    echo ""
    echo "terraform {"
    echo "  backend \"s3\" {"
    echo "    bucket         = \"$BUCKET_NAME\""
    echo "    key            = \"path/to/your/terraform.tfstate\""
    echo "    region         = \"$REGION\""
    echo "    encrypt        = true"
    echo "    dynamodb_table = \"$TABLE_NAME\""
    echo "  }"
    echo "}"
    echo ""
    echo "For OpenTofu, the configuration is identical. Just use 'tofu init' instead of 'terraform init'."
    echo "----------------------------------------"
    log_info "Your backend infrastructure is ready!"
}

main() {
    log_info "Starting Terraform/OpenTofu remote state bootstrap"

    log_info "Checking if bucket '$BUCKET_NAME' exists..."
    if bucket_exists; then
        log_info "Bucket '$BUCKET_NAME' already exists."
    else
        create_s3_bucket
    fi

    log_info "Checking if DynamoDB table '$TABLE_NAME' exists..."
    if table_exists; then
        log_info "DynamoDB table '$TABLE_NAME' already exists."
    else
        create_dynamodb_table
    fi

    print_configuration
}

main "$@"
