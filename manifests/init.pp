# == Class: deploy
#
# This module is used to deploy archive files such as tar.gz and tar.bz2
#
# === Parameters
#
# Document parameters here.
#
# [*tempdir*]
#   The temporary dir where the archived files can be downloaded too.
#   Defaults to /var/tmp/deploy.
#
# === Examples
#
#  class { 'deploy':
#    tempdir => '/opt/deploy'
#  }
#
# === Authors
#
# Merritt Krakowitzer
#
# === Copyright
#
# Copyright (c) 2012 Merritt Krakowitzer
#
# Published under the Apache License, Version 2.0
#
class deploy(
  $tempdir = '/var/tmp/deploy'
) {

  file { $tempdir:
    ensure => directory,
  }

}
