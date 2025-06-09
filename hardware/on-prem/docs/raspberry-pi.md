# raspberry-pi

## Notes

- Create bootable MicroSD via `rpi-imager` (i.e. `sudo -E rpi-imager`)
- Use Raspian 64-bit lite for the base install.
- Customize w/ username/password.

Run the following generic install:

Configure wifi.

```
# Enable WiFi radio
nmcli radio wifi on

# List available WiFi networks
nmcli device wifi list

# Connect to a WiFi network (prompts for password)
nmcli device wifi connect <SSID> --ask

# OR: Connect to a WiFi network (provide password directly)
nmcli device wifi connect <SSID> password <wifi_password>

# Show active connections
nmcli connection show --active

# Show device status
nmcli device status

# Disconnect from a WiFi network
nmcli connection down <SSID>
```

Set-up tailscale

```
wget https://tailscale.com/install.sh
chmod u+x install.sh
./install.sh
sudo tailscale up --ssh
# Disable the key expiry for this new node
```
