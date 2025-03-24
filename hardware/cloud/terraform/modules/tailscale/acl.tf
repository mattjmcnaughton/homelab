# ACL configuration with your full ACL
resource "tailscale_acl" "my_acl" {
  acl = jsonencode({
    // Define the tags which can be applied to devices and by which users.
    "tagOwners" : {
      "tag:homelab-auto-provision" : ["autogroup:admin"],
    },

    // Define access control lists for users, groups, autogroups, tags,
    // Tailscale IP addresses, and subnet ranges.
    "acls" : [
      // Allow all connections.
      { "action" : "accept", "src" : ["*"], "dst" : ["*:*"] },
    ],
    "ssh" : [
      // The default SSH policy, which lets users SSH into devices they own.
      {
        "action" : "check",
        "src" : ["autogroup:member"],
        "dst" : ["autogroup:self"],
        "users" : ["autogroup:nonroot", "root"],
      },
    ],
  })
}
