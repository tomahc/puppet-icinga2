define icinga2::notification (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $assign                   = undef,
  $ignore                   = undef,
  $apply_to                 = undef,

  $host_name                = undef,
  $service_name             = undef,
  $vars                     = undef,
  $groups                   = undef,
  $users                    = undef,
  $user_groups              = undef,
  $times                    = undef,
  $command                  = undef,
  $interval                 = undef,
  $period                   = undef,
  $zone                     = undef,
  $types                    = undef,
  $states                   = undef,

  $notification_configs     = $icinga2::server::notification_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $notification_configs,
    default => $notification_configs,
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/notification.conf.erb'),
    notify  => Service[$service],
  }
}
