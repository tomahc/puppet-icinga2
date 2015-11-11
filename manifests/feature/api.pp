class icinga2::feature::api (
  $ensure,

  $cert_path                = $icinga2::params::cert_path,
  $key_path                 = $icinga2::params::key_path,
  $ca_path                  = $icinga2::params::ca_path,
  $accept_commands          = $icinga2::params::accept_commands,
  $ticket_salt              = $icinga2::params::ticket_salt,

  $host_configs             = $icinga2::server::host_configs,
  $service                  = $icinga2::server::service,

) inherits icinga2::params {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  file { "${icinga2::params::confdir}/features-available/api.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/feature/api.conf.erb'),
    notify  => Service[$service],
  }
}
