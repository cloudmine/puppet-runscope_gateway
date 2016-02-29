# == Class: runscope_gateway::params
#
# This class sets default parameters based on node facts.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
class runscope_gateway::params {
  case $::architecture {
    'amd64', 'x86_64': { $runscope_arch = 'amd64' }
    'i386':            { $runscope_arch = '386'   }
    default:           {
      fail("runscope_gateway: Unimplemented kernel architecture: ${::architecture}")
    }
  }

  if $::kernel == 'Darwin' {
    $config_dir       = '/usr/local/etc/runscope'
    $install_binary   = 'runscope-gateway'
    $install_dir      = '/usr/local/opt/runscope'
    $runscope_os_type = 'darwin'
    $service_style    = 'launchd'
  }
  elsif $::kernel == 'Linux' {
    $config_dir       = '/etc/runscope'
    $install_binary   = 'runscope-gateway'
    $install_dir      = '/opt/runscope'
    $runscope_os_type = 'linux'

    if $::operatingsystem == 'Amazon' {
      $service_style = 'sysv'
    }
    elsif $::operatingsystem =~ /Archlinux|Fedora|OpenSuSE/ {
      $service_style = 'systemd'
    }
    elsif $::operatingsystem =~ /CentOS|OracleLinux|RedHat|Scientific/ {
      if versioncmp($::operatingsystemrelease, '7.0') < 0 {
        $service_style = 'sysv'
      }
      else {
        $service_style = 'systemd'
      }
    }
    elsif $::operatingsystem == 'Debian' {
      if versioncmp($::operatingsystemrelease, '8.0') < 0 {
        $service_style = 'debian'
      }
      else {
        $service_style = 'systemd'
      }
    }
    elsif $::operatingsystem =~ /SLE[SD]/ {
      if versioncmp($::operatingsystemrelease, '12.0') < 0 {
        $service_style = 'sles'
      }
      else {
        $service_style = 'systemd'
      }
    }
    elsif $::operatingsystem == 'Ubuntu' {
      if versioncmp($::operatingsystemrelease, '15.04') < 0 {
        $service_style = 'upstart'
      }
      else {
        $service_style = 'systemd'
      }
    }
    else {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
  elsif $::kernel == 'Windows' {
    $config_dir       = 'c:/Program Files/Runscope'
    $install_binary   = 'runscope-gateway.exe'
    $install_dir      = 'c:/Program Files/Runscope'
    $runscope_os_type = 'windows'
    $service_style    = 'scm'
  }
  else {
    fail("Module ${module_name} is not supported on ${::kernel}")
  }

  $url = "https://s3.amazonaws.com/runscope-downloads/runscope-gateway/latest/${runscope_os_type}-${runscope_arch}/runscope-gateway.zip"
}
