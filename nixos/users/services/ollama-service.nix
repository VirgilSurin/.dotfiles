{ config, lib, pkgs, ... }:

{
    systemd.services.ollama = {
    description = "Ollama Service";
    after = [ "network-online.target" ];

    # Set up the service parameters
    serviceConfig = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve && ${pkgs.ollama}/bin/ollama run llama3.1:latest";
      User = "ollama";
      Group = "ollama";
      Restart = "always";
      RestartSec = 3;
      Environment = "PATH=$PATH";
    };

    # Enable the service to start on boot
    wantedBy = [ "default.target" ];
  };
}
