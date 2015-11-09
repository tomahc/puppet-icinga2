# private class

class icinga2::server::cert (
  $ensure,

  $master, 
  $ticket                     = undef,
  $confdir                    = pick($icinga2::server::confdir, $icinga2::params::confdir),
  $service                    = pick($icinga2::server::service, $icinga2::params::server_service),
) {

  $real_ensure = $ensure ? {
    /(true|present)/ => 'present',
    /(false|absent)/ => 'absent',
    default          => 'present',
  }

  file { 'fix-pki-directory-permissions':
    ensure => directory,
    path   => "${confdir}/pki",
    owner  => 'nagios',
    group  => 'nagios',
    mode   => '0755',
  }

  file  { 'puppet-cert':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.crt",
    owner  => 'nagios',
    group  => 'nagios',
    source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  }

  file  { 'puppet-key':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.key",
    owner  => 'nagios',
    group  => 'nagios',
    source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  }

  exec { 'request-master-cert':
    path    => [ '/usr/sbin', '/usr/bin' ],
    command => "sudo -H -u nagios icinga2 pki save-cert --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --host ${master}",
    creates => "${confdir}/pki/trusted-master.crt",
  }

  exec { 'request-master-ca':
    path    => [ '/usr/sbin', '/usr/bin' ],
    command => "sudo -H -u nagios icinga2 pki request --host ${master} --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --ca ${confdir}/pki/ca.crt --ticket ${ticket}",
    creates => "${confdir}/pki/ca.crt",
  }

  exec { "${::fqdn}-endpoint":
    path    => [ '/usr/sbin', '/usr/bin' ],
    command => "sudo -H -u nagios icinga2 node setup --endpoint ${::fqdn} --zone ${::fqdn} --master_host ${master} --trustedcert ${confdir}/pki/trusted-master.crt --ticket ${ticket}",
  }

  #file { '/var/lib/icinga2/ca':
  #  ensure => directory,
  #  owner  => $icinga2::server::user,
  #  group  => $icinga2::server::group,
  #  mode   => '0755',
  #}

  #exec { 'copy-master-ca':
  #  path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
  #  command => "sudo -H -u nagios cp ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
  #  unless  => "diff ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
  #}
}
