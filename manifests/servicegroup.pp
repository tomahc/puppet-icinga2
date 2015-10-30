define icinga2::servicegroup (
  $ensure,

  $display_name             = $title,
  $groups                   = undef,

  $assign                   = undef,
  $ignore                   = undef,

  $service                  = $icinga2::server::service,
  $servicegroup_configs     = $icinga2::server::servicegroup_configs,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  file { "${icinga2::params::confdir}/${servicegroup_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/servicegroup.conf.erb'),
    notify  => Service[$service],
  }
}
