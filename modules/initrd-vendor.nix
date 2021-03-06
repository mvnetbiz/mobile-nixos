# This module handles well-known "vendor" partitions.
#
# Relevant upstream documentation:
#  * https://www.kernel.org/doc/html/v4.14/driver-api/firmware/fw_search_path.html
#
# Note that we'll be using `firmware_class.path=/vendor/firmware` on the
# command-line to make the firmware path known ASAP without requiring run-time
# configuration. The NixOS stage-2 will configure `/sys/module/firmware_class/parameters/path`
# as expected.
{ config, lib, ... }:

let
  device_info = config.mobile.device.info;
  vendor_device =
    if device_info ? vendor_partition
    then device_info.vendor_partition
    else null
  ;
in
lib.mkMerge [
  (lib.mkIf (vendor_device != null) {
    # FIXME: add "firmware_class.path=/vendor/firmware" to kernel cmdline
    boot.specialFileSystems = {
      "/vendor" = {
        device = vendor_device;
        fsType = "ext4";
        options = [ "nosuid" "noexec" "nodev" ];
      };
    };
  })
]
