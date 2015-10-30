define icinga2::usergroup (
  $ensure,

  $display_name             = $title,
  $groups                   = undef,

  $assign                   = undef,
  $ignore                   = undef,

  $service                  = $icinga2::server::service,
  $usergroup_configs        = $icinga2::server::usergroup_configs,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  file { "${icinga2::params::confdir}/${usergroup_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/usergroup.conf.erb'),
    notify  => Service[$service],
  }
}
