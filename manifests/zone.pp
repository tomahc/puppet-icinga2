define icinga2::zone (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $enpoints                 = undef,
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

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $zone_configs,
    default => fail("No such option: ${is_template}"),
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/zone.conf.erb'),
    notify  => Service[$service],
  }
}
