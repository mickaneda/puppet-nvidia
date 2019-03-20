class nvidia(
  $install_cuda_rpm = false,
  $rpm_cuda_source = "https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-10.1.105-1.x86_64.rpm",
  $cuda_version = ["10-0"],
  $driver = "http://us.download.nvidia.com/XFree86/Linux-x86_64/418.43/NVIDIA-Linux-x86_64-418.43.run",
  $installer = "",
){
  if $install_cuda_rpm {
    package {$rpm_cuda:
      ensure => "installed",
      source => $rpm_cuda_source,
      provider => "rpm",
    }
  }
  if $cuda_version =~ Array {
    $cuda_versions = $cuda_version
  }elsif $cuda_version == "" {
    $cuda_versions = []
  }else {
    $cuda_versions = [$cuda_version]
  }
  $cuda_versions.each | $c | {
    package {"cuda-${c}":
      ensure => "installed",
      notify => Reboot['after_run'],
    }
  }
  reboot { 'after_run':
    apply  => finished,
  }
  if $driver != "" {
    $installer = "/tmp/nvidia_driver.sh"
    file {"nvidia_driver_installation file":
      path => $installer,
      source => "puppet:///modules/${module_name}/nvidia_driver.sh",
      mode => "0755",
    }
    exec {"nvidia_driver_installation":
      command => "${installer}"
    }
  }
}
