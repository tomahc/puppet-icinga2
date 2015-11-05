define icinga2::downtime (
  $ensure,

  $apply_to,
  $assign                   = undef,
  $ignore                   = undef,

  $host_name                = undef,
  $service_name             = undef,
  $author                   = 'icinga2',
  $comment                  = 'Generic Comment',
  $fixed                    = undef,
  $duration                 = undef,
  $ranges                   = undef,

  $downtime_configs         = $icinga2::server::downtime_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  $type_state = $apply_to ? {
    'Host'    => [ 'Up' ],
    'Service' => [ 'OK', 'Warning' ],
    default   => fail("No such option: ${apply_to}"),
  }

  file { "${icinga2::params::confdir}/${downtime_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/downtime.conf.erb'),
    notify  => Service[$service],
  }
}
