class icinga2::params {
  $server_package                         = 'icinga2'
  $server_service                         = 'icinga2'
  $server_user                            = 'nagios'
  $confdir                                = '/etc/icinga2'
  $server_config                          = "${confdir}/icinga2.conf"

  $server_config_include                  = ['constants.conf', 'zones.conf', 'features-enabled/*.conf']
  $server_config_include_recursive        = ['repository.d', 'conf.d']

  $template_configs                       = 'templates.d'
  $host_configs                           = 'hosts.d'
  $user_configs                           = 'users.d'
  $service_configs                        = 'services.d'
  $notification_configs                   = 'notifications.d'
  $command_configs                        = 'commands.d'
  $timeperiod_configs                     = 'timeperiods.d'
  $dependency_configs                     = 'dependencies.d'

  $server_config_template                 = 'icinga2/server/icinga2.conf.erb'

  $hostgroup_configs                      = 'hostgroups.d'
  $usergroup_configs                      = 'usergroups.d'
  $servicegroup_configs                   = 'servicegroups.d'

}
