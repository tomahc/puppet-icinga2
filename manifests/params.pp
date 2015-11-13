class icinga2::params inherits icinga2::globals {

  case $::osfamily {
    'Debian': {
      $server_package                     = pick($icinga2::globals::server_package, 'icinga2')
      $server_service                     = pick($icinga2::globals::server_service, 'icinga2')
      $service_user                       = pick($icinga2::globals::service_user, 'nagios')
      $service_group                      = pick($icinga2::globals::service_group, 'nagios')

      # constants
      $plugindir                          = pick($icinga2::globals::plugindir, '/usr/lib/nagios/plugins')
      $manubulonplugindir                 = pick($icinga2::globals::manubulonplugindir, '/usr/lib/nagios/plugins')
      $plugincontribdir                   = pick($icinga2::globals::plugincontribdir, '/usr/lib/nagios/plugins')
    }
    'RedHat': {
      $server_package                     = pick($icinga2::globals::server_package, 'icinga2')
      $server_service                     = pick($icinga2::globals::server_service, 'icinga2')
      $service_user                       = pick($icinga2::globals::service_user, 'icinga')
      $service_group                      = pick($icinga2::globals::service_group, 'icinga')

      # constants
      $plugindir                          = pick($icinga2::globals::plugindir, '/usr/lib64/nagios/plugins')
      $manubulonplugindir                 = pick($icinga2::globals::manubulonplugindir, '/usr/lib64/nagios/plugins')
      $plugincontribdir                   = pick($icinga2::globals::plugincontribdir, '/usr/lib64/nagios/plugins')
    }
  }

  $confdir                                = pick($icinga2::globals::confdir, '/etc/icinga2')
  $server_config                          = "${confdir}/icinga2.conf"

  $include_files                          = pick($icinga2::globals::include_files, ['constants.conf', 'zones.conf', 'features-enabled/*.conf'])
  $include_directories                    = pick($icinga2::globals::include_directories, ['repository.d', 'conf.d'])

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
  $zonename                               = pick($icinga2::globals::zonename, $::fqdn)
  $nodename                               = pick($icinga2::globals::nodename, $::fqdn)
  $ticketsalt                             = $icinga2::globals::ticketsalt

  # api
  $cert_path                              = 'SysconfDir + "/icinga2/pki/" + NodeName + ".crt"'
  $key_path                               = 'SysconfDir + "/icinga2/pki/" + NodeName + ".key"'
  $ca_path                                = 'SysconfDir + "/icinga2/pki/ca.crt"'
  $accept_commands                        = true
  $ticket_salt                            = 'TicketSalt'
}
