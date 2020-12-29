{ pkgs ? import <nixpkgs> {}, tag ? "latest" }:

let
  matrix-registration = import ./shell.nix {};

in pkgs.dockerTools.buildImage {
  name = "matrix-registration";
  tag = tag;
  created = "now";

  contents = [ matrix-registration ];

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir /data
    cp ${matrix-registration}/config/config.sample.yaml /data/
  '';

  config = { 
    Entrypoint = [
      "${matrix-registration}/bin/matrix-registration"
      "--config-path=/data/config.yaml"
      ];
    WorkingDir = "/data";
    Volumes = {
      "/data" = {};
    };
    ExposedPorts = {
      "5000/tcp" = {};
    };
  };
}
