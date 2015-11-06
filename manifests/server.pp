class icinga2::server (
  $package                    = $icinga2::params::server_package,
  $service                    = $icinga2::params::server_service,
  $config                     = $icinga2::params::server_config,
  $confdir                    = $icinga2::params::confdir,
  $user                       = $icinga2::params::server_user,

  $include_files              = $icinga2::params::server_config_include,
  $include_directories        = $icinga2::params::server_config_include_recursive,

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
  $zone_configs           = $icinga2::params::zone_configs,

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
  }

  icinga2::server::paths { $hostgroup_configs: }
  icinga2::server::paths { $usergroup_configs: }
  icinga2::server::paths { $servicegroup_configs: }

  icinga2::server::paths { $template_configs: }
  icinga2::server::paths { $host_configs: }
  icinga2::server::paths { $user_configs: }
  icinga2::server::paths { $service_configs: }
  icinga2::server::paths { $notification_configs: }
  icinga2::server::paths { $command_configs: }
  icinga2::server::paths { $timeperiod_configs: }
  icinga2::server::paths { $dependency_configs: }
  icinga2::server::paths { $downtime_configs: }
  icinga2::server::paths { $zone_configs: }

  service { $service:
    ensure  => running,
    enable  => true,
    require => [
      Package[$package],
      File[$config],
    ],
  }
}
