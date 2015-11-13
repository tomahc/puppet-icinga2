class icinga2::globals (
  $server_package                         = undef,
  $server_service                         = undef,

  $service_user                           = undef,
  $service_group                          = undef,

  $confdir                                = undef,

  $nagios_plugins                         = undef,
  
  $include_files                          = undef,
  $include_directories                    = undef,

  # constants
  $plugindir                              = undef,
  $manubulonplugindir                     = undef,
  $plugincontribdir                       = undef,
  $zonename                               = undef,
  $nodename                               = undef,
  $ticketsalt                             = undef,
) {
}
