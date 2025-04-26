# traefik-proxy

Heavily based on at [hectorm/docker-proxy](https://github.com/hectorm/docker-proxy)
[1e1c76d900441683134f55ececdd4a8a8ba36bbf](https://github.com/hectorm/docker-proxy/commit/1e1c76d900441683134f55ececdd4a8a8ba36bbf).

`docker-proxy` has the MIT license as of the linked commit and the code is small
enough to fully audit.

Find the README for the original project below.

---

## Upstream

Traefik image pre-configured to act as a transparent proxy. It allows containers without direct Internet access to connect to specific hosts.

## Usage

```yaml
services:

  yourapp:
    image: "registry.example.com/yourapp:latest"
    networks:
      private:

  proxy:
    image: "docker.io/hectorm/proxy:v3"
    networks:
      public:
      private:
        aliases:
          - "example.com"
          - "example.net"
          - "smtp.example.com"
          - "postgres.example.com"
          - "mysql.example.com"
    environment:
      PROXY_UPSTREAMS: |
        example.com:443:tls
        example.net:443:tls
        smtp.example.com:465:tls
        smtp.example.com:587:tcp
        postgres.example.com:5432:tls
        mysql.example.com:3306:tcp

networks:

  public:
    internal: false

  private:
    internal: true
```

> [!NOTE]
> For the `tls` kind, the proxy inspects the SNI to determine the target host. For other kinds, the proxy does not inspect the traffic and will throw an error if the same protocol and port combination is used for multiple hosts.
