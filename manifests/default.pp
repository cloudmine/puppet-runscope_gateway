# == Class: runscope_gateway::default
#
# Vagrant default class.
#
# === Copyright:
#
# Copyright (c) 2016 CloudMine, Inc. http://cloudmineinc.com/
# See project LICENSE file for full information.
#
exec { 'apt-get':
  command => 'apt-get update',
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
} ->
# For archive module
package { 'unzip': } ->
class { '::runscope_gateway': }
