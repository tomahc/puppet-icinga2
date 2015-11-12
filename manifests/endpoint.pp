define icinga2::endpoint (
  $ensure,

  $host                     = undef,
  $port                     = undef,

  $endpoint_configs         = $icinga2::server::endpoint_configs,
  $service                  = $icinga2::server::service,

) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  file { "${icinga2::params::confdir}/${endpoint_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/endpoint.conf.erb'),
    notify  => Service[$service],
  }
}
