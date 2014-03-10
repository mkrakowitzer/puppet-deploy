# == Definition: deploy::untar
#
# This definition is used to extract zip files
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
#
# [*owner*]
#   Define which user will owner deployed files. You need to declare this user.
#   This parameter is required
#
# [*group*]
#   Define which group will owner deployed files. You need to declare this group.
#   This parameter is required
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
define deploy::unzip (
  $target,
  $command,
  $command_options,
  $owner,
  $group
) {

  $file = $title

  if $owner != undef {
    exec { "deployunzip_chown_${target}":
      command     => "/bin/chown ${owner} -R ${target}",
      subscribe   => Exec["untarball_${file}"],
      refreshonly => true,
      require     => [ Exec["untarball_${file}"] ];
    }
  }
  if $group != undef {
    exec { "deployunzip_chgrp_${target}":
      command     => "/bin/chgrp ${group} -R ${target}",
      subscribe   => Exec["untarball_${file}"],
      refreshonly => true,
      require     => [ Exec["untarball_${file}"] ];
    }

  }

  file { $target:
    ensure  => directory
  }
  # Uncompress downloaded file
  $_cmd = "${command} ${command_options} ${file} -d ${target} "
  exec { "deployunzip_${file}":
    command     => $_cmd,
    subscribe   => File[$target],
    refreshonly => true,
    require     => [ File[$target] ];
  }
}