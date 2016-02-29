# == Class: runscope_gateway::config
#
# This class handles configuring the Runscope Gateway Agent and service
# if applicable.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
class runscope_gateway::config inherits runscope_gateway {
  # Avoid duplicate File declaration on Windows from install_dir
  if $::operatingsystem != 'Windows' {
    file { $runscope_gateway::config_dir:
      ensure => directory,
    }
  }

  file { "${runscope_gateway::config_dir}/gateway.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('runscope_gateway/gateway.conf.erb'),
  }

  if $runscope_gateway::service_manage {
    case $runscope_gateway::service_style {
      # 'debian': {
      #   file { '/etc/init.d/runscope-gateway':
      #     ensure  => file,
      #     owner   => 'root',
      #     group   => 'root',
      #     mode    => '0755',
      #     content => template('runscope_gateway/runscope-gateway.debian.erb'),
      #   }
      # }
      'launchd' : {
        file { '/Library/LaunchDaemons/com.runscope.gateway.plist':
          ensure  => file,
          owner   => 'root',
          group   => 'wheel',
          mode    => '0644',
          content => template('runscope_gateway/runscope-gateway.launchd.erb'),
        }
      }
      'scm': {
        exec { 'sc-create-runscope-gateway':
          command => "c:/windows/system32/sc.exe create runscope-gateway start= auto binpath= \"${runscope_gateway::install_dir}/${runscope_gateway::install_binary}\" displayname= \"Runscope Gateway Agent\"",
          unless  => 'c:/windows/system32/sc.exe test runscope-gateway',
        }
      }
      'systemd': {
        file { '/lib/systemd/system/runscope-gateway.service':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template('runscope_gateway/runscope-gateway.systemd.erb'),
        } ~>
        exec { 'runscope-gateway-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      # 'sysv': {
      #   file { '/etc/init.d/runscope-gateway':
      #     ensure  => file,
      #     owner   => 'root',
      #     group   => 'root',
      #     mode    => '0755',
      #     content => template('runscope_gateway/runscope-gateway.sysv.erb'),
      #   }
      # }
      'upstart': {
        file { '/etc/init/runscope-gateway.conf':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template('runscope_gateway/runscope-gateway.upstart.erb'),
        }
        file { '/etc/init.d/runscope-gateway':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      default: {
        fail("runscope_gateway: Unimplemented service configuration: ${runscope_gateway::service_style}")
      }
    }
  }
}
