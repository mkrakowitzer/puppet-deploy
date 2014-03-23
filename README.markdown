#puppet-deploy
[![Build
Status](https://travis-ci.org/mkrakowitzer/puppet-deploy.svg)](https://travis-ci.org/mkrakowitzer/puppet-deploy)
##Overview

This module downloads and extracts compressed files to a specific directory.

The following archives are supported:

* .tar.gz
* .tgz
* .tar.bz2
* .tar.xz

###Setup Requirements

##Usage
```puppet
    # Set the default temp directory to use
    class { 'deploy':
      tempdir => '/opt/deploy'
    }

    # Deploy Java tar file
    deploy::file { 'jdk-7u21-linux-x64.tar.gz':
      target  => '/opt/development-tools/java/jdk1.7.0_21',
      url     => 'http://mywebsite.co.za/development-tools/java',
      strip   => true,
    }
  
    # Deploy another tar file
    deploy::file { 'jdk-8-ea-bin-b90-linux-x64-16_may_2013.tar.gz':
      target  => '/opt/development-tools/java/jdk1.8.0_b90',
      url     => 'http://server.co.za/development-tools/java/',
      strip   => true,
    }

    deploy::file { 'apache-maven-3.0.5-bin.tar.gz':
      target  => '/opt/development-tools/apache-maven',
      url     => 'http://server/pub/apache-maven/',
      strip   => true
      version => '1',
      package => 'maven'
    }
```
###Classes:
* `deploy` - set the default working directory.

###Definitions:
* `deploy::file` - Deploy a compressed file to a target directory.

#### Common Parameters

*target*
  
  * The target directory to decompress the archive file too.
  * This parameter is required

*url*
  
  * The URL where the file can be downloaded from.
  * This parameter is required. Do no specify the file name in the URL.

*owner*

  * Define which user will owner deployed files. You need to declare this user.

*group*

  * Define which group will owner deployed files. You need to declare this group.
  * Defaults to undefined

*strip*
 
  * Strip root directory from archive file   
  * Defaults to 'false'

*strip_level*

  * Levels to strip from root directory from archive file
  * Defaults to '1'

*version*
   
   * Define an arbitrary version number for the tar file. Must be an integer.
   * **WARNING**: Incrementing this version number removes target directory and 
   and redeploys tar file. Both version and package must be defined.
   * Defaults to undefined

*package*
   
   * define an arbitrary package name for the tar file. 
   * creates a static fact [package]\_version in /etc/facter/facts.d/ with
   file name [package].yaml. Both version and package must be defined.
   * Defaults to undefined
   * requires facter 1.7.x
   * requires the /etc/facter/facts.d/ directory structure to be in place.

**If you decide to use the version and package parameters you get to keep both
pieces if it breaks. I certainly don't recommend managing packages this way.**

##Limitations
* I'm sure there are many

###Supported Operating Systems:

* Ubuntu (12.04 LTS tested)
* Red Hat family (RHEL 5 and 6 tested)

##Development

* Copyright (C) 2013 Merritt Krakowitzer - <merritt@krakowitzer.com>
* Distributed under the terms of the Apache License, Version 2.0.
* Please submit a pull request or issue on [GitHub](https://github.com/mkrakowitzer/puppet-deploy)

## Contributors
* Jonathan Johnson
* Andreyev Dias de Melo

