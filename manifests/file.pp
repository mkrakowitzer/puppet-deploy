# == Definition: deploy::file
#
# This definition is used to deploy tar files
#
# === Parameters
#
# [*target*]
#   The target directory to decompress the archive file too.
#   This parameter is required
#
# [*url*]
#   The URL where the file can be downloaded from.
#   This parameter is required. Do no specify the file name in the URL.
#
# [*command*]
#   The path to the tar command.
#   Defaults to '/bin/tar'
#
# [*command_options*]
#   Overwrite the default command options. You probably don't want to do this.
#   Defaults to undef
#
# [*fetch*]
#   The path to the wget command.
#   Defaults to '/usr/bin/wget'
#
# [*fetch_options*]
#   Overwrite the default wget options. You probably don't want to do this.
#   Defaults to '-q -c --no-check-certificate -O'
#
# [*owner*]
#   Define which user will owner deployed files. You need to declare this user. 
#
# [*group*]
#   Define which group will owner deployed files. You need to declare this group.
#
# [*strip*]
#   Strip root directory from archive file
#   Defaults to 'false'
#
# [*version*]
#   Define an arbitrary version number for the tar file. Must be an integer.
#   WARNING: Incrementing this version number removes target directory and
#   and redeploys tar file. Both version and package must be defined.
#   Defaults to undefined
#
# [*package*]
#   define an arbitrary package name for the tar file.
#   creates a static fact [package]_version in /etc/facter/facts.d/ with
#   file name [package].yaml. Both version and package must be defined.
#   Defaults to undefined
#   requires facter 1.7.x
#   requires the /etc/facter/facts.d/ directory structure to be in place.
#
# === Examples
#
#  deploy::file { 'jdk-7u21-linux-x64.tar.gz':
#    target  => '/opt/development-tools/java/jdk1.7.0_21',
#    url     => 'http://server.co.za/cobbler/pub/software/java',
#    strip   => true
#  }
#
#  deploy::file { 'apache-maven-3.0.5-bin.tar.gz':
#    target  => '/opt/development-tools/apache-maven',
#    url     => 'http://server.co.za/cobbler/development-tools/apache-maven/',
#    require => File['/opt/development-tools/apache-maven'],
#    strip   => true
#    version => '21',
#    package => 'maven'
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
define deploy::file (
  $target,
  $url,
  $command         = '/bin/tar',
  $command_options = undef,
  $fetch           = '/usr/bin/wget',
  $fetch_options   = '-q -c --no-check-certificate -O',
  $strip           = false,
  $version         = undef,
  $package         = undef,
  $owner           = undef,
  $group           = undef,
) {

  $file = $title

  if $owner != undef { $_owner = "--owner $owner" }
  if $group != undef { $_group = "--group $group" }

  # Strip root directory from archive file
  if $strip == true {
    $strip_options = '--strip 1'
  } else {
    $strip_options = ''
  }

  # Set default uncompress flags for archives we know.
  if $command_options == undef {
    if $file =~ /.tar.gz$|.tgz$/ {
      $dl_cmd_options = 'xzf'
    } elsif $file =~ /.tar.bz2$/ {
      $dl_cmd_options = 'xjf'
    } elsif $file =~ /.tar.xz$/ {
      $dl_cmd_options = 'xJf'
    } else {
      fail('Dont know type')
    }
  }

  # Very experimental right now. Attemt to do some kind of version management.
  if $version != undef and $package != undef {
    file { "/etc/facter/facts.d/${package}.yaml":
      ensure  => file,
      content => "${package}_version: ${version}\n",
    }
    $val1 = inline_template("<% @${package}_version = 0 if @${package}_version.nil? %><% return @${package}_version %>")
    if $version > $val1 {
      exec { "rm_${target}":
        command   => "rm -rf ${target}",
        onlyif    => "test -d ${target}",
        before    => Exec["download_${file}"],
      }
    }
  }

  # Download the compressed file to deploy directory
  exec { "download_${file}":
    command => "${fetch} ${fetch_options} ${deploy::tempdir}/${file} ${url}/${file}",
    creates => "${deploy::tempdir}/${file}",
    unless  => "test -d ${target}",
    notify  => File[$target],
    require => File[$deploy::tempdir]
  }

  file { $target:
    ensure  => directory,
    require => Exec["download_${file}"],
  }

  # Uncompress downloaded file
  exec { "untarball_${file}":
    command     => "${command} ${dl_cmd_options} ${deploy::tempdir}/${file} -C ${target} ${strip_options} --no-same-owner ${_owner} ${_group}",
    subscribe   => File[$target],
    refreshonly => true,
    require     => [ File[$target], Exec["download_${file}"] ];
  }

  # Remove the downloaded files after they have been uncompressed.
  exec { "cleanup_${file}":
    command   => "rm -f ${deploy::tempdir}/${file}",
    onlyif    => "test -f ${deploy::tempdir}/${file}",
    require   => Exec["untarball_${file}"],
    subscribe => Exec["untarball_${file}"];
  }

}
