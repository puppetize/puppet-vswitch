class vswitch::ovs(
  $package_ensure = 'present'
) {
  case $::osfamily {
    Debian: {
      ensure_resource(
        'package',
        "linux-headers-${::kernelrelease}",
        {'ensure' => 'present' }
      )
      package {["openvswitch-switch", "openvswitch-datapath-dkms"]:
        ensure  => $package_ensure,
        require => Package["linux-headers-${::kernelrelease}"],
        before  => Service['openvswitch-switch'],
      }
    }
  }

  service {"openvswitch-switch":
    ensure      => true,
    enable      => true,
    hasstatus   => true,
    status      => "/etc/init.d/openvswitch-switch status",
  }
}
