# nixos-modules

Collection of useful NixOS modules.

## Usage

Add the following import line to your `/etc/nixos/configuration.nix`
to import all of the provided modules.

```nix
  imports = [
    "${builtins.fetchTarball https://github.com/vpsfreecz/nixos-modules/archive/master.tar.gz}"
  ];
```

## Provided modules

- [Libvirt with NixOS managed network bridge](modules/libvirt.nix), see [examples/libvirt.nix](examples/libvirt.nix)
