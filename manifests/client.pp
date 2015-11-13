class icinga2::client (
  $ensure,

  $master_endpoint,

  $use_puppet_ca              = $icinga2::params::use_puppet_ca,

  $confdir                    = $icinga2::params::confdir,

  $service_user               = $icinga2::params::service_user,
  $service_group              = $icinga2::params::service_group,
  $service                    = $icinga2::params::server_service,

) inherits icinga2::params {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'present',
    /(false|absent)/      => 'absent',
    default               => 'present',
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

  icinga2::feature { 'api':
    ensure => 'enabled',
  }

  icinga2::feature { 'notification':
    ensure => 'disabled',
  }

  class { 'icinga2::constants':
    ensure     => present,
    nodename   => $::fqdn,
    zonename   => $::fqdn,
    ticketsalt => '',
  }

  class { 'icinga2::server':
    include_directories => [ 'zones.d', 'endpoints.d' ],
    include_files       => ['constants.conf', 'features-enabled/*.conf'], 
    is_master           => false,
    use_puppet_ca       => true,
    master              => $master_endpoint,
  }

  class { 'icinga2::feature::api':
    ensure          => present,
    accept_commands => true,
  }
}
