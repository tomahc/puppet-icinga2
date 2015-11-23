class icinga2::server (
  $package                    = $icinga2::params::server_package,
  $service                    = $icinga2::params::server_service,
  $config                     = $icinga2::params::server_config,
  $confdir                    = $icinga2::params::confdir,
  $user                       = $icinga2::params::service_user,
  $group                      = $icinga2::params::service_group,

  $master                     = $::fqdn,

  $plugincontribdir           = $icinga2::params::plugincontribdir,

  $is_master                  = $icinga2::params::is_master,
  $use_puppet_ca              = $icinga2::params::use_puppet_ca,

  $nagios_plugins             = $icinga2::params::nagios_plugins,

  $ticketsalt                 = $icinga2::params::ticketsalt,
  $include_files              = $icinga2::params::include_files,
  $include_directories        = $icinga2::params::include_directories,

  $server_config_template     = $icinga2::params::server_config_template,

  $template_configs           = $icinga2::params::template_configs,
  $host_configs               = $icinga2::params::host_configs,
  $user_configs               = $icinga2::params::user_configs,
  $service_configs            = $icinga2::params::service_configs,
  $notification_configs       = $icinga2::params::notification_configs,
  $command_configs            = $icinga2::params::command_configs,
  $timeperiod_configs         = $icinga2::params::timeperiod_configs,
  $dependency_configs         = $icinga2::params::dependency_configs,
  $downtime_configs           = $icinga2::params::downtime_configs,
  $zone_configs               = $icinga2::params::zone_configs,
  $endpoint_configs           = $icinga2::params::endpoint_configs,

  $hostgroup_configs          = $icinga2::params::hostgroup_configs,
  $usergroup_configs          = $icinga2::params::usergroup_configs,
  $servicegroup_configs       = $icinga2::params::servicegroup_configs,

) inherits icinga2::params {

  package { $server_package:
    ensure => present,
  }

  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($server_config_template),
    notify  => Service[$service],
    require => Package[$package],
  }

  icinga2::server::paths { $include_directories: }

  package { $nagios_plugins:
    ensure => present,
  }

  if $use_puppet_ca {
    class { 'icinga2::server::cert':
      ensure    => present,
      master    => $master,
      is_master => $is_master,
      require   => Package[$package],
    }
  }

  exec { "create ${plugincontribdir}":
    path    => ['/bin', '/usr/bin'],
    command => "mkdir -p ${plugincontribdir}",
    unless  => "test -e ${plugincontribdir}",
  }->

  file { 'contribplugins':
    ensure  => directory,
    recurse => true,
    purge   => false,
    path    => $plugincontribdir,
    source  => 'icinga2/contrib_plugins',
  }

  service { $service:
    ensure  => running,
    enable  => true,
    require => [
      Package[$package],
      File[$config],
    ],
  }
}
