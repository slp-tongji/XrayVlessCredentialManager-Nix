{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule (finalAttrs: {
  pname = "xray-vless-credential-manager";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "slp-tongji";
    repo = "XrayVlessCredentialManager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YDaxC1SyMcBl/F8NdzT0IEQ3o+M1mEljyfvJc1De/co=";
  };

  projectFile = "src/XrayVlessCredentialManager/XrayVlessCredentialManager.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  nugetDeps = ./deps.nix;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "A credential manager for Xray VLESS inbounds that creates, queries and revokes VLESS credentials.";
    homepage = "https://github.com/slp-tongji/XrayVlessCredentialManager";
    license = lib.licenses.mit;
    mainProgram = "XrayVlessCredentialManager";
    maintainers = [ ];
  };
})
