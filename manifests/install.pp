# == Class: runscope_gateway::install
#
# This class handles fetching and installing the Runscope Gateway Agent.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
class runscope_gateway::install inherits runscope_gateway {
  include ::archive

  file { $runscope_gateway::install_dir:
    ensure => directory,
  } ->

  archive { "${runscope_gateway::install_dir}/runscope-gateway.zip":
    ensure       => $runscope_gateway::ensure,
    creates      => "${runscope_gateway::install_dir}/${runscope_gateway::install_binary}",
    extract      => true,
    extract_path => $runscope_gateway::install_dir,
    source       => $runscope_gateway::url,
  }

  if $runscope_gateway::user_manage {
    user { $runscope_gateway::user:
      ensure => present,
      system => true,
    }

    if $runscope_gateway::group_manage {
      Group[$runscope_gateway::group] -> User[$runscope_gateway::user]
    }
  }
  if $runscope_gateway::group_manage {
    group { $runscope_gateway::group:
      ensure => present,
      system => true,
    }
  }
}
