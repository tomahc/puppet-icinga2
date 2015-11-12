define icinga2::user (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $display_name             = $name,
  $email                    = undef,
  $pager                    = undef,
  $vars                     = undef,
  $groups                   = undef,
  $enable_notifications     = true,
  $period                   = undef,
  $types                    = undef,
  $states                   = undef,

  $user_configs             = $icinga2::server::user_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $user_configs,
    default => $user_configs,
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/user.conf.erb'),
    notify  => Service[$service],
  }
}
