define icinga2::command::check (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $contrib                  = false,

  $execute                  = undef,
  $command                  = undef,
  $env                      = undef,
  $vars                     = undef,
  $timeout                  = undef,
  $arguments                = undef,

  $command_configs          = $icinga2::server::command_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $command_configs,
    default => $command_configs,
  }

  file { "${icinga2::params::confdir}/${$real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/commands/check.conf.erb'),
    notify  => Service[$service],
  }
}
