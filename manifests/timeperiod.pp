define icinga2::timeperiod (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $display_name             = $name,
  $update                   = undef,
  $ranges                   = undef,

  $timeperiod_configs       = $icinga2::server::timeperiod_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $timeperiod_configs,
    default => $timeperiod_configs,
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/timeperiod.conf.erb'),
    notify  => Service[$service],
  }
}
