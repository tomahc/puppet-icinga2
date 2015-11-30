## Description

Puppet Module to manage icinga2 configs.
This module does not configure the Database Backend, but manages your ido config.

## Server

```
class { 'icinga2::server':
  is_master => true,
}
```

## Client

Install with:

```
class { 'icinga2::client':
  ensure => present,
}
```

## Create a Host Template

```
icinga2::host { 'generic-host':
  ensure 			=> present,
  is_template		=> true,
  check_interval	=> '1m',
  retry_interval	=> '30s',
  check_command		=> 'hostalive4',
  vars => {
    'disks' => {
      'root' => {
        disk_partitions => [ '/' ]
      }
    }
  }
}
```

## Create a Host

```
icinga2::host { 'host1.domain.tld':
  ensure	=> present,
  templates => [ 'generic-host' ],
  groups	=> [ 'Hostgroup1' ],
}
```

## Create a Service Template

```
icinga2::service { 'generic-service':
  ensure 				=> present,
  is_template			=> true,
  max_check_attempts 	=> 5,
  enable_flapping		=> false,
}
```

## Create a Service

```
icinga2::service { 'disks':
  ensure 			=> present,
  is_template		=> false,
  templates			=> [ 'generic-service' ],
  groups			=> [ 'basic_services' ],
  loop_condition 	=> 'host.vars.disks',
  check_command 	=> 'disks',
  assign 			=> 'host.vars.os == "Linux" && host.vars.disks',
  ignore 			=> 'host.vars.downtime',
}
```

## Create a custom CheckComand

```
icinga2::command::check { 'my-check':
  ensure => present,
  contrib => true,
  templates => [ 'plugin-check-command' ],
  command => [ 'my_check_script' ],
  arguments => |
    {
      "-a" = "$var1$"
      "-b" = "$var2$"
    }
}
```
  