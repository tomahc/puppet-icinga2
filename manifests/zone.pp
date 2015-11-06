define icinga2::zone (
  $ensure,

  $endpoints                = [ $name ],
  $parent                   = undef,
  $global                   = undef,

  $zone_configs             = $icinga2::server::zone_configs,
  $service                  = $icinga2::server::service,

) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  file { "${icinga2::params::confdir}/${zone_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/zone.conf.erb'),
    notify  => Service[$service],
  }
}
