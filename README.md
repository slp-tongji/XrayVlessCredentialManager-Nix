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

---

All documentation and `description` fields in this repository are AI-generated.
