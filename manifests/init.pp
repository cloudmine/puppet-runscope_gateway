# == Class: runscope_gateway
#
# This class handles coordinating the installation, configuration, and runtime
# of the Runscope Gateway Agent.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
class runscope_gateway (
  $certfile       = undef,
  $config_dir     = $runscope_gateway::params::config_dir,
  $ensure         = present,
  $group          = 'runscope',
  $group_manage   = true,
  $hostname       = $::fqdn,
  $http           = true,
  $http_port      = 8000,
  $https          = false,
  $https_port     = 8443,
  $install_binary = $runscope_gateway::params::install_binary,
  $install_dir    = $runscope_gateway::params::install_dir,
  $interface      = undef,
  $keyfile        = undef,
  $service_enable = true,
  $service_ensure = running,
  $service_manage = true,
  $service_style  = $runscope_gateway::params::service_style,
  $token          = undef,
  $url            = $runscope_gateway::params::url,
  $user           = 'runscope',
  $user_manage    = true,
) inherits runscope_gateway::params {

  if $token == undef or $token == '' {
    fail('runscope_gateway: Please provide Runscope application token')
  }

  if $https {
    if $certfile == undef or $certfile == '' {
      fail('runscope_gateway: Please provide certfile when enabling HTTPS')
    }
    if $keyfile == undef or $keyfile == '' {
      fail('runscope_gateway: Please provide keyfile when enabling HTTPS')
    }
  }

  anchor { 'runscope_gateway::begin': } ->
  class { '::runscope_gateway::install': } ->
  class { '::runscope_gateway::config': } ->
  class { '::runscope_gateway::service': }
  anchor { 'runscope_gateway::end': }
}
