define icinga2::host (
  $ensure,

  $is_template              = false,
  $templates                = undef,

  $display_name             = $name,
  $address                  = $::ipaddress,
  $check_command            = undef,
  $address6                 = undef,
  $groups                   = undef,
  $vars                     = undef,
  $max_check_attempts       = undef,
  $check_period             = undef,
  $check_interval           = undef,
  $retry_interval           = undef,
  $enable_notifications     = undef,
  $enable_active_checks     = undef,
  $enable_passive_checks    = undef,
  $enable_event_handler     = undef,
  $enable_flapping          = undef,
  $enable_perfdata          = undef,
  $event_command            = undef,
  $flapping_threshold       = undef,
  $volatile                 = undef,
  $zone                     = undef,
  $command_endpoint         = undef,
  $notes                    = undef,
  $notes_url                = undef,
  $action_url               = undef,
  $icon_image               = undef,
  $icon_image_alt           = undef,

  $host_configs             = $icinga2::server::host_configs,
  $service                  = $icinga2::server::service,

) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => fail("No such option: ${ensure}"),
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $host_configs,
    default => fail("No such option: ${is_template}"),
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/host.conf.erb'),
    notify  => Service[$service],
  }
}
