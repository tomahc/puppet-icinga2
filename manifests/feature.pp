define icinga2::feature (
  $ensure,

) {

  $real_ensure = $ensure ? {
    /(enable|enabled)/   => 'enable',
    /(disable|disabled)/ => 'disable',
    default              => 'enable',
  }

  $exec_condition = $real_ensure ? {
    'enable'  => '!',
    'disable' => '',
  }

  exec { "${real_ensure}-${name}":
    command     => "icinga2 feature ${real_ensure} ${name}",
    path        => ['/usr/sbin', '/usr/bin'],
    onlyif      => ["test ${exec_condition} -e /etc/icinga2/features-enabled/${name}.conf"],
    notify      => Service[$icinga2::server::service],
  }
}

