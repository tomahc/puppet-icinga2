# private class

define icinga2::server::paths (
  $ensure         = 'directory',
  $confdir        = $icinga2::server::confdir,
  $service        = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|directory)/ => 'directory',
    /(false|absent)/           => 'absent',
    default                    => 'directory',
  }

  # make sure config direcories exist
  file { "${confdir}/${name}":
    ensure => $real_ensure,
    owner  => root,
    group  => root,
    mode   => '0755',
    notify => Service[$service],
  }
}
