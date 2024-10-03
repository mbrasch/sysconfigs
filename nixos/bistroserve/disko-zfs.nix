{disks ? ["/dev/vda"], ...}: {
  disk = {
    nixos = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            type = "partition";
            name = "ESP";
            start = "0";
            end = "2GiB";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            type = "partition";
            name = "root";
            start = "2GiB";
            end = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          }
        ];
      };
    };
  };

  zpool = {
    zroot = {
      type = "zpool";
      rootFsOptions = {
        compression = "lz4";
        "com.sun:auto-snapshot" = "false";
      };
      mountpoint = "/";

      datasets = {
        "root" = {
          zfs_type = "filesystem";
          #mountpoint = "/";
          options.mountpoint = "none";
        };
        "root/var" = {
          zfs_type = "filesystem";
          mountpoint = "/var";
          options."com.sun:auto-snapshot" = "true";
        };
        "root/home" = {
          zfs_type = "filesystem";
          mountpoint = "/home";
          options."com.sun:auto-snapshot" = "true";
        };
        "root/tmp" = {
          zfs_type = "filesystem";
          mountpoint = "/tmp";
          options."com.sun:auto-snapshot" = "true";
        };
        "root/usr" = {
          zfs_type = "filesystem";
          mountpoint = "/usr";
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
}
