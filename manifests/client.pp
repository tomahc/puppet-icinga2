class icinga2::client (
  $ensure,

  $master_endpoint,

  $use_puppet_ca              = $icinga2::params::use_puppet_ca,

  $service_user               = $icinga2::params::service_user,
  $service_group              = $icinga2::params::service_group,
  $confdir                    = $icinga2::params::confdir,

) inherits icinga2::params {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'present',
    /(false|absent)/      => 'absent',
    default               => 'present',
  }
  
  class { 'icinga2::server':
    include_directories => [ 'zones.d', 'endpoints.d' ],
    include_files       => ['constants.conf', 'features-enabled/*.conf'], 
    is_master           => false,
  }

  file { "${confdir}/constants.conf":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/client/constants.conf.erb'),
  }

  icinga2::endpoint { $master_endpoint:
    ensure => present,
    host   => $master_endpoint,
  }

  icinga2::endpoint { $::fqdn:
    ensure => present,
  }

  icinga2::zone { 'master':
    ensure    => present,
    endpoints => [ $master_endpoint ],
  }

  icinga2::zone { $::fqdn:
    ensure    => present,
    endpoints => [ $::fqdn ],
    parent    => 'master',
  }

  $ticket = request_ticket('puppet.local.inovex.de')

  if $use_puppet_ca {
    class { 'icinga2::server::cert':
      ensure => present,
      master => $master_endpoint,
      ticket => $ticket,
    }
  }

  icinga2::feature { 'api':
    ensure => 'enabled',
  }

  icinga2::feature { 'notification':
    ensure => 'disabled',
  }
}
