{ config, pkgs, lib, ... }:
{
  imports = [
    "${builtins.fetchTarball https://github.com/vpsfreecz/nixos-modules/archive/master.tar.gz}"
  ];

  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      infiniteLeaseTime = true;
    };
  };

  # example of port forwarding from port 11122
  # to libvirt guest port 22
  networking.nat = {
     forwardPorts = [
       { destination = "192.168.122.101:22"; sourcePort = 11122;}
     ];
  }
}
