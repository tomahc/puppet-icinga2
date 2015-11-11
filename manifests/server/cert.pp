# private class

class icinga2::server::cert (
  $ensure,

  $master, 
  $is_master                  = false,
  $confdir                    = $icinga2::server::confdir,
  $service                    = $icinga2::server::service,
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

  file  { 'copy-puppet-cert':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.crt",
    owner  => 'nagios',
    group  => 'nagios',
    source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  }

  file  { 'copy-puppet-key':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.key",
    owner  => 'nagios',
    group  => 'nagios',
    source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  }

  file  { 'copy-puppet-ca':
    ensure => $real_ensure,
    path   => "${confdir}/pki/ca.crt",
    owner  => 'nagios',
    group  => 'nagios',
    source => "/var/lib/puppet/ssl/certs/ca.pem",
  }

  if $is_master {

    file { '/var/lib/icinga2/ca':
      ensure => directory,
      owner  => $icinga2::server::user,
      group  => $icinga2::server::group,
      mode   => '0755',
    }->

    exec { 'save-master-ca':
      path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
      command => "sudo -H -u nagios cp ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
      unless  => "diff ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
    }
  } else {

    $ticket = request_ticket('puppet.local.inovex.de')

    exec { 'request-master-cert':
      path    => [ '/usr/sbin', '/usr/bin' ],
      command => "sudo -H -u nagios icinga2 pki save-cert --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --host ${master}",
      creates => "${confdir}/pki/trusted-master.crt",
    }->

    # Resignig the already signed cert results in loosing the client cert on the 1st puppet run.
    # A 2nd puppet run will recopy the signed puppet agent cert and resign it. It is reproducable by copying the puppet agents key and cert and run `icinga pki request` manually.
    # The reason why it fails is still unknown.

    # TODO
    # Q: why u fail 1st run?!
    # A: I dunno... yet!
    
    # Q: does it fail, if cert is unsigned?
    # A: yes, it does!
    # Q: Why?
    # A: I dunno... yet!

    #exec { 'request-master-ca':
    #  path    => [ '/usr/sbin', '/usr/bin' ],
    #  command => "sudo -H -u nagios icinga2 pki request --host ${master} --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --ca ${confdir}/pki/ca.crt --ticket ${ticket}",
    #  creates => "${confdir}/pki/ca.crt",
    #}->

    exec { "${::fqdn}-endpoint":
      path    => [ '/usr/sbin', '/usr/bin' ],
      command => "sudo -H -u nagios icinga2 node setup --endpoint ${::fqdn} --zone ${::fqdn} --master_host ${master} --trustedcert ${confdir}/pki/trusted-master.crt --ticket ${ticket}",
    }
  }
}
