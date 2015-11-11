define icinga2::ido (
  $ensure,

  $type,

  $user,
  $password,
  $host,
  $database,

  $host_configs             = $icinga2::server::host_configs,
  $service                  = $icinga2::server::service,

) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  case $type {
    'mysql': {
      $library = 'db_ido_mysql'
      $object = 'IdoMysqlConnection'
    }
    'psql': {
      fail("Not implemented yet: ${type}")
    }
    default: {
      fail("Unknown type: ${type}")
    }
  }

  file { "${icinga2::params::confdir}/features-available/ido-mysql.conf":
    ensure  => $real_ensure,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0640',
    content => template('icinga2/objects/ido.conf.erb'),
    notify  => Service[$service],
  }
}
