{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.virtualisation.libvirtd.networking;
in
{
  options = {
    virtualisation.libvirtd.networking = {
      enable = mkEnableOption "Enable nix-managed networking for libvirt";

      bridgeName = mkOption {
        type = types.str;
        default = "br0";
        description = "Name of the bridged interface for use by libvirt guests";
      };

      infiniteLeaseTime = mkOption {
        type = types.bool;
        default = false;
        description = "Use infinite lease time for DHCP used by guests";
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = [ "Make sure to enable KVM and TUN/TAP features" ];

    system.activationScripts.libvirtImages = ''
      mkdir -p /var/lib/libvirt/images
    '';

    networking.nat = {
       enable = true;
       internalInterfaces = [ cfg.bridgeName ];
       externalInterface = "venet0";
     };

     # libvirt uses 192.168.122.0
     networking.bridges."${cfg.bridgeName}".interfaces = [];
     networking.interfaces."${cfg.bridgeName}".ipv4.addresses = [
       { address = "192.168.122.1"; prefixLength = 24; }
     ];

     services.dhcpd4 = {
       enable = true;
       interfaces = [ cfg.bridgeName ];
       extraConfig = ''
         option routers 192.168.122.1;
         option broadcast-address 192.168.122.255;
         option subnet-mask 255.255.255.0;

         option domain-name-servers 37.205.9.100, 37.205.10.88, 1.1.1.1;

         ${optionalString cfg.infiniteLeaseTime  ''
         default-lease-time -1;
         max-lease-time -1;
         ''}

         subnet 192.168.122.0 netmask 255.255.255.0 {
           range 192.168.122.100 192.168.122.200;
         }
       '';
     };
  };
}
