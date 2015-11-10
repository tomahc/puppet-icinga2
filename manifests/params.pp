class icinga2::params inherits icinga2::globals {
  $server_package                         = $icinga2::globals::server_package
  $server_service                         = $icinga2::globals::server_service
  $service_user                           = $icinga2::globals::service_user
  $service_group                          = $icinga2::globals::service_group
  $confdir                                = $icinga2::globals::confdir
  $server_config                          = "${confdir}/icinga2.conf"

  $include_files                          = $icinga2::globals::include_files
  $include_directories                    = $icinga2::globals::include_directories

  $is_master                              = true
  $use_puppet_ca                          = true

  $template_configs                       = 'templates.d'
  $host_configs                           = 'hosts.d'
  $user_configs                           = 'users.d'
  $service_configs                        = 'services.d'
  $notification_configs                   = 'notifications.d'
  $command_configs                        = 'commands.d'
  $timeperiod_configs                     = 'timeperiods.d'
  $dependency_configs                     = 'dependencies.d'
  $downtime_configs                       = 'downtimes.d'
  $zone_configs                           = 'zones.d'
  $endpoint_configs                       = 'endpoints.d'

  $server_config_template                 = 'icinga2/server/icinga2.conf.erb'

  $hostgroup_configs                      = 'hostgroups.d'
  $usergroup_configs                      = 'usergroups.d'
  $servicegroup_configs                   = 'servicegroups.d'

  # constants
  $plugindir                              = $icinga2::globals::plugindir
  $manubulonplugindir                     = $icinga2::globals::manubulonplugindir
  $plugincontribdir                       = $icinga2::globals::plugincontribdir
  $zonename                               = $icinga2::globals::zonename
  $ticketsalt                             = $icinga2::globals::ticketsalt
  $nodename                               = $icinga2::globals::nodename

}
