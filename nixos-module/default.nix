{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xray-vless-credential-manager;
in
{
  options.services.xray-vless-credential-manager = {
    enable = lib.mkEnableOption "XrayVlessCredentialManager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../package { };
      description = "The XrayVlessCredentialManager package to use.";
    };

    xrayApi = lib.mkOption {
      type = lib.types.str;
      description = "Address of the Xray gRPC API (e.g. `http://127.0.0.1:10085`).";
    };

    inboundTag = lib.mkOption {
      type = lib.types.str;
      description = "Tag of the Xray VLESS inbound whose users are managed.";
    };

    credentialManagerPort = lib.mkOption {
      type = lib.types.port;
      description = "Port on which the credential manager API listens (on loopback).";
    };

    stateDirectory = lib.mkOption {
      type = lib.types.str;
      default = "xray-vless-credential-manager";
      description = "systemd `StateDirectory` (under `/var/lib`) where the credential database is stored.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.xray-vless-credential-manager = {
      description = "XrayVlessCredentialManager";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = cfg.stateDirectory;
        ExecStart = lib.concatStringsSep " " [
          (lib.getExe cfg.package)
          "run"
          "--xray-api"
          cfg.xrayApi
          "--inbound-tag"
          cfg.inboundTag
          "--credential-manager-port"
          (toString cfg.credentialManagerPort)
          "--credential-database"
          "/var/lib/${cfg.stateDirectory}/credentials.db"
        ];
        Restart = "on-failure";
      };
    };
  };
}
