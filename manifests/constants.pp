class icinga2::constants (
  $ensure,

  $plugindir            = undef,
  $manubulonplugindir   = undef,
  $plugincontribdir     = undef,
  $zonename             = undef,
  $ticketsalt           = undef,
  $nodename             = undef,

  $service              = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  file { "${icinga2::params::confdir}/constants.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/server/constants.conf.erb'),
    notify  => Service[$service],
  }
}
