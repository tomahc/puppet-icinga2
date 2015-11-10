class icinga2::constants (
  $ensure,

  $plugindir                              = $icinga2::params::plugindir,
  $manubulonplugindir                     = $icinga2::params::manubulonplugindir,
  $plugincontribdir                       = $icinga2::params::plugincontribdir,
  $nodename                               = $icinga2::params::nodename,
  $zonename                               = $icinga2::params::zonename,
  $ticketsalt                             = $icinga2::params::ticketsalt,

  $confdir                                = $icinga2::params::confdir,
  $service                                = $icinga2::params::server_service,
) inherits icinga2::params {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  file { "${confdir}/constants.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/server/constants.conf.erb'),
    notify  => Service[$service],
  }
}
