define icinga2::dependency (
  $ensure,

  $apply_to,
  $assign                   = undef,
  $ignore                   = undef,

  $parent_host_name         = undef,
  $parent_service_name      = undef,
  $child_host_name          = undef,
  $child_service_name       = undef,
  $disable_checks           = false,
  $disable_notifications    = true,
  $ignore_soft_states       = true,
  $period                   = undef,
  $states                   = undef,

  $dependency_configs       = $icinga2::server::dependency_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  case $apply_to {
    'Host': {
      $type_state = [ 'Up' ]
    }
    'Service': {
      $type_state = [ 'OK', 'Warning' ]
    }
    default: {
      fail("Invalid option: $apply_to")
    }
  }

  file { "${icinga2::params::confdir}/${dependency_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/dependency.conf.erb'),
    notify  => Service[$service],
  }
}
