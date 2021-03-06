# private class

class icinga2::server::cert (
  $ensure,

  $master, 
  $is_master                  = false,
  $confdir                    = $icinga2::server::confdir,

  $service_user               = $icinga2::server::service_user,
  $service_group              = $icinga2::server::service_group,
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
    owner  => $service_user,
    group  => $service_group,
    mode   => '0755',
  }

  file  { 'copy-puppet-cert':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.crt",
    owner  => $service_user,
    group  => $service_group,
    source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  }

  file  { 'copy-puppet-key':
    ensure => $real_ensure,
    path   => "${confdir}/pki/${::fqdn}.key",
    owner  => $service_user,
    group  => $service_group,
    source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  }

  file  { 'copy-puppet-ca':
    ensure => $real_ensure,
    path   => "${confdir}/pki/ca.crt",
    owner  => $service_user,
    group  => $service_group,
    source => "/var/lib/puppet/ssl/certs/ca.pem",
  }

  if $is_master {

    file { '/var/lib/icinga2/ca':
      ensure => directory,
      owner  => $service_user,
      group  => $service_group,
      mode   => '0755',
    }->

    exec { 'save-master-ca':
      path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
      command => "sudo -H -u ${service_user} cp ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
      unless  => "diff ${confdir}/pki/ca.crt /var/lib/icinga2/ca/ca.crt",
    }
  } else {

    #$ticket = request_ticket('puppet.local.inovex.de')

    exec { 'request-master-cert':
      path    => [ '/usr/sbin', '/usr/bin' ],
      command => "sudo -H -u ${service_user} icinga2 pki save-cert --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --host ${master}",
      creates => "${confdir}/pki/trusted-master.crt",
    }

    # FIX

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
    #  command => "sudo -H -u ${service_user} icinga2 pki request --host ${master} --key ${confdir}/pki/${::fqdn}.key --cert ${confdir}/pki/${::fqdn}.crt --trustedcert ${confdir}/pki/trusted-master.crt --ca ${confdir}/pki/ca.crt --ticket ${ticket}",
    #  creates => "${confdir}/pki/ca.crt",
    #}->

    # since the signed puppet agent certicate is being used, the icinga2 agent does not need to call "node setup", which would result in requesting the master ca and resigning the client cert. 
    # however: placeholder for future implementation of self-signed certs

    #exec { "${::fqdn}-endpoint":
    #  path    => [ '/usr/sbin', '/usr/bin' ],
    #  command => "sudo -H -u ${service_user} icinga2 node setup --endpoint ${::fqdn} --zone ${::fqdn} --master_host ${master} --trustedcert ${confdir}/pki/trusted-master.crt --ticket ${ticket}",
    #}
  }
}
