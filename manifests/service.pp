# == Class: runscope_gateway::service
#
# This class handles running the Runscope Gateway Agent as a service.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
class runscope_gateway::service inherits runscope_gateway {
  if $runscope_gateway::service_manage {
    service { 'runscope-gateway':
      ensure => $runscope_gateway::service_ensure,
      enable => $runscope_gateway::service_enable,
    }
  }
}
