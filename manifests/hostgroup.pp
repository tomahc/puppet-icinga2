define icinga2::hostgroup (
  $ensure,

  $display_name             = $title,
  $groups                   = undef,

  $assign                   = undef,
  $ignore                   = undef,

  $service                  = $icinga2::server::service,
  $hostgroup_configs        = $icinga2::server::hostgroup_configs,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  file { "${icinga2::params::confdir}/${hostgroup_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/hostgroup.conf.erb'),
    notify  => Service[$service],
  }
}
