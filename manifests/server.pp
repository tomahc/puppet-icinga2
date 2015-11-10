class icinga2::server (
  $package                    = $icinga2::params::server_package,
  $service                    = $icinga2::params::server_service,
  $config                     = $icinga2::params::server_config,
  $confdir                    = $icinga2::params::confdir,
  $user                       = $icinga2::params::service_user,
  $group                      = $icinga2::params::service_group,

  $master                     = $::fqdn,

  $is_master                  = $icinga2::params::is_master,
  $use_puppet_ca              = $icinga2::params::use_puppet_ca,

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

  #icinga2::server::paths { $hostgroup_configs: }
  #icinga2::server::paths { $usergroup_configs: }
  #icinga2::server::paths { $servicegroup_configs: }

  #icinga2::server::paths { $template_configs: }
  #icinga2::server::paths { $host_configs: }
  #icinga2::server::paths { $user_configs: }
  #icinga2::server::paths { $service_configs: }
  #icinga2::server::paths { $notification_configs: }
  #icinga2::server::paths { $command_configs: }
  #icinga2::server::paths { $timeperiod_configs: }
  #icinga2::server::paths { $dependency_configs: }
  #icinga2::server::paths { $downtime_configs: }
  #icinga2::server::paths { $zone_configs: }
  #icinga2::server::paths { $endpoint_configs: }

  if $use_puppet_ca {
    class { 'icinga2::server::cert':
      ensure    => present,
      master    => $master,
      is_master => $is_master,
      require   => Package[$package],
    }
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
