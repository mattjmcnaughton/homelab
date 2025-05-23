resource "aws_instance" "instance" {
  ami           = var.ami_id != null ? var.ami_id : data.aws_ssm_parameter.ubuntu_2404_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name != null ? var.key_name : null

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  # I have to assign a public ip address... even though I'm not allowing any external
  # incoming connections.
  #
  # Otherwise, I need to setup a NAT Gateway, which costs money.
  # Assigning a public ip does not cost money.
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.public.ids[0]
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  # TODO: Use cloud-config to create `mattjmcnaughton` as the uid 1000 user.

  # User data script from template
  user_data = templatefile("${path.module}/templates/user_data.tftpl", {
    username         = var.username
    ts_auth_key_name = var.secrets_manager_ts_auth_key_name
    instance_name    = var.instance_name

    install_base_packages_ubuntu_2404_script = file("${path.module}/files/install-base-packages-ubuntu-2404.sh")
    install_tailscale_ubuntu_2404_script     = file("${path.module}/files/install-tailscale-ubuntu-2404.sh")
    launch_tailscale_script                  = file("${path.module}/files/launch-tailscale.sh")
    create_user_linux_script                 = file("${path.module}/files/create-user-linux.sh")
  })
  user_data_replace_on_change = false # Do not replace the machine when user data changes.

  # Tags
  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}

# Only create the EBS volume if data_volume_size > 0
resource "aws_ebs_volume" "data_volume" {
  count             = var.data_volume_size > 0 ? 1 : 0
  availability_zone = aws_instance.instance.availability_zone
  size              = var.data_volume_size
  encrypted         = true
  type              = var.data_volume_type

  tags = merge(
    var.tags,
    {
      Name = "${var.instance_name}-data-volume"
    }
  )
}

# Only attach the volume if it was created
resource "aws_volume_attachment" "data_volume_attachment" {
  count       = var.data_volume_size > 0 ? 1 : 0
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_volume[0].id
  instance_id = aws_instance.instance.id
}
