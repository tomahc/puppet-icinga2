class icinga2::globals (
  $server_package                         = 'icinga2',
  $server_service                         = 'icinga2',
  $service_user                           = 'nagios',
  $service_group                          = 'nagios',
  $confdir                                = '/etc/icinga2',
  
  $include_files                          = ['constants.conf', 'zones.conf', 'features-enabled/*.conf'],
  $include_directories                    = ['repository.d', 'conf.d'],

  # constants
  $plugindir                              = '/usr/lib/nagios/plugins',
  $manubulonplugindir                     = '/usr/lib/nagios/plugins',
  $plugincontribdir                       = '/usr/lib/nagios/plugins',
  $zonename                               = $::fqdn,
  $nodename                               = $::fqdn,
  $ticketsalt                             = undef,
) {
}
