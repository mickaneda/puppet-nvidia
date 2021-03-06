class nvidia(
  $kernel_devel = true,
  $epel_release = true,
  $cuda_repo = "cuda-repo-rhel7",
  $cuda_rpm_source = "https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-10.1.105-1.x86_64.rpm",
  $cuda_version = ["10-0"],
  $driver = "http://us.download.nvidia.com/XFree86/Linux-x86_64/418.43/NVIDIA-Linux-x86_64-418.43.run",
  $cudnn = {
    "10-1" => "http://developer.download.nvidia.com/compute/redist/cudnn/v7.5.0/cudnn-10.1-linux-x64-v7.5.0.56.tgz",
    "10-0" => "http://developer.download.nvidia.com/compute/redist/cudnn/v7.5.0/cudnn-10.0-linux-x64-v7.5.0.56.tgz",
    "9-2" => "http://developer.download.nvidia.com/compute/redist/cudnn/v7.5.0/cudnn-9.2-linux-x64-v7.5.0.56.tgz",
  },
){
  package {$cuda_repo:
    ensure => "installed",
    source => $cuda_rpm_source,
    provider => "rpm",
  }
  if $kernel_devel {
    package {"kernel-devel":
      ensure => "installed",
    }
  }
  if $epel_release {
    package {"epel-release":
      ensure => "installed",
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
    if $cudnn[$c] {
      file {"script_cudnn_for_cuda-${c}":
        path => "/tmp/cudnn_${c}.sh",
        source => "puppet:///modules/${module_name}/cudnn.sh",
        mode => "0755",
      }
      exec {"install_cudnn_for_cuda-${c}":
        command => "/tmp/cudnn_${c}.sh ${c} ${cudnn[$c]}",
        require => File["script_cudnn_for_cuda-${c}"],
      }
    }
  }
  reboot { "after_run":
    apply  => immediately,
    timeout  => 0,
  }
  file {"local_directory":
    ensure => "directory",
    path => "/usr/local",
    mode => "0755",
  }
  file {"cuda_setup_file":
    path => "/usr/local/setup_cuda.sh",
    source => "puppet:///modules/${module_name}/setup_cuda.sh",
    mode => "0644",
  }
  if $driver != "" {
    $installer = "/tmp/nvidia_driver.sh"
    file {"nvidia_driver_installation file":
      path => $installer,
      source => "puppet:///modules/${module_name}/nvidia_driver.sh",
      mode => "0755",
      require => Reboot['after_run'],
    }
    exec {"nvidia_driver_installation":
      command => "${installer} ${driver}",
      require => File['nvidia_driver_installation file'],
      timeout => 1800,
    }
  }
}
