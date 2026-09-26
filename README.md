# XrayVlessCredentialManager-Nix

Nix packaging for [XrayVlessCredentialManager](https://github.com/slp-tongji/XrayVlessCredentialManager) — a credential manager for Xray VLESS inbounds that creates, queries and revokes VLESS credentials via the Xray gRPC API.

## Adding as a flake input

```nix
{
  inputs = {
    xray-vless-credential-manager.url = "github:slp-tongji/XrayVlessCredentialManager-Nix";
  };
}
```

## Package

The binary is exposed as `XrayVlessCredentialManager`:

```nix
xray-vless-credential-manager.packages.${system}.xray-vless-credential-manager
```

Or try it directly from the CLI:

```console
$ nix shell github:slp-tongji/XrayVlessCredentialManager-Nix
$ XrayVlessCredentialManager run \
    --xray-api http://127.0.0.1:10085 \
    --inbound-tag vless-inbound \
    --credential-manager-port 8081 \
    --credential-database /tmp/credentials.db
```

## NixOS module

A module is exposed as `nixosModules.xray-vless-credential-manager` (also
available as `nixosModules.default`):

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xray-vless-credential-manager.url = "github:slp-tongji/XrayVlessCredentialManager-Nix";
  };

  outputs = { nixpkgs, xray-vless-credential-manager, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        xray-vless-credential-manager.nixosModules.default
        {
          services.xray-vless-credential-manager = {
            enable = true;
            xrayApi = "http://127.0.0.1:10085";
            inboundTag = "vless-inbound";
            credentialManagerPort = 8081;
          };
        }
      ];
    };
  };
}
```

The module runs the service as a systemd unit with a dynamic system user and a
`StateDirectory` for the credential database.

Options under `services.xray-vless-credential-manager`:

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `enable` | bool | `false` | Whether to enable the service |
| `package` | package | this flake's package | The package to install |
| `xrayApi` | str | (required) | Address of the Xray gRPC API |
| `inboundTag` | str | (required) | Tag of the Xray VLESS inbound whose users are managed |
| `credentialManagerPort` | port | (required) | Port the credential manager API listens on (loopback) |
| `stateDirectory` | str | `"xray-vless-credential-manager"` | systemd `StateDirectory` (under `/var/lib`) holding the credential database |

---

All documentation and `description` fields in this repository are AI-generated.
