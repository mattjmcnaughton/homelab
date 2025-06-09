# Installation

## Install Media

- Ensure we have the [raspberry-pi imager](https://www.raspberrypi.com/software/) installed.
    - On nix, we can use the `rpi-imager` package.
    - We need to run it via `sudo -E rpi-imager` to ensure we can write the
      media.
    - Use a MicroSD/USB adapter to attach install media.
- Follow the instructions [here](https://www.home-assistant.io/installation/raspberrypi/#write-the-image-to-your-sd-card).
    - We select the default Home Assistant image.

## Initial Launch

- Add the MicroSD card to the Raspberry Pi. Ensure we've connected via ethernet.
  We need ethernet for the initial connection.
    - Connect a monitor.
- Connect the power which will start the boot.
- After boot is complete, the `banner` will show the IP address.
    - For me, the `homeassistant.local` isn't working. We need to use the IP.
        - We can also use `nmap` to discover the IP. We can run `nmap -sn
          192.168.1.0/24` (assuming 192.168.1.0 is the CIDR).

## Initial configuration

- Navigate to `http://$IP:8123`.
    - Enter a default username/password.
- Navigate to `/config/intergrations/dashboard`.
    - Select "Add Integration > Mqtt > Mqtt"
        - Use the default Mqtt add-on.
- Navigate to Add-ons
    - Add the "File editor" add on.
        - Set "Start on Boot", "Watch Dog" and "Show in Sidebar" to true.
        - Update Configuration with the following from
          https://github.com/hassio-addons/addon-tailscale/blob/27994089fc86340157e53944a7d5af0c4c88394d/tailscale/DOCS.md#option-proxy.
        ```
            - http:
              use_x_forwarded_for: true
                trusted_proxies:
                    - 127.0.0.1
        ```
    - Add the "Tailscale" add on.
        - Set "Start on Boot" and "Watchdog" to true. Do not set "Show in
          Sidebar".
        - Update the configuration to set "Tailscale Proxy" to true. Set the
          "Proxy and Funnel port" to 443.
        - Look in the Tailscale logs for a url to use for authentication. The
          Tailscale "UI" in the sidebar doesn't work.
            - In Tailscale UI, grant permissions for Subnets, but do not grant permissions as an
              Exit Note. Disable key node expiry.
        - Access `https://homeassistant.$TAILNET`.
            - Restart homeassistant to confirm surviving reboot.
    - Download and use the iOS app.

## TODO

- Backup strategy.
- First X projects.
