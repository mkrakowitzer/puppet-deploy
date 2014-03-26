# == Definition: deploy::untar
#
# This definition is used to extract tar files
#
# === Parameters
#
# [*target*]
#   The target directory to decompress the archive file too.
#   This parameter is required
#
# [*command*]
#   The path to the tar command.
#   This parameter is required
#
# [*command_options*]
#   Overwrite the default command options. You probably don't want to do this.
#   This parameter is required

# [*strip*]
#   Strip root directory from archive file
#   This parameter is required
#
# [*strip_level*]
#   Levels to strip from root directory from archive file
#   This parameter is required
#
# [*owner*]
#   Define which user will owner deployed files. You need to declare this user.
#   This parameter is required
#
# [*group*]
#   Define which group will owner deployed files. You need to declare this group.
#   This parameter is required
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
define deploy::untar (
  $target,
  $command,
  $command_options,
  $strip,
  $strip_level,
  $owner,
  $group,
) {

  $file = $title

  # Strip root directory from archive file
  if $strip == true {
    $strip_options = "--strip ${strip_level}"
  } else {
    $strip_options = ''
  }

  # Set default uncompress flags for archives we know.
  if $command_options == undef {
    if $file =~ /.tar$/ {
      $dl_cmd_options = 'xf'
    } elsif $file =~ /.tar.gz$|.tgz$/ {
      $dl_cmd_options = 'xzf'
    } elsif $file =~ /.tar.bz2$/ {
      $dl_cmd_options = 'xjf'
    } elsif $file =~ /.tar.xz$/ {
      $dl_cmd_options = 'xJf'
    } else {
      fail('Dont know type')
    }
  }
  file { $target:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  }
  # Uncompress downloaded file
  $_cmd = "${command} ${dl_cmd_options} ${file} -C ${target} ${strip_options} --no-same-owner"
  exec { "untarball_${file}":
    command     => $_cmd,
    subscribe   => File[$target],
    refreshonly => true,
    user        => $owner,
    group       => $group,
    require     => [ File[$target] ];
  }
}
