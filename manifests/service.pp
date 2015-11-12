define icinga2::service (
  $ensure,

  $is_template              = false,
  $templates                = undef,
  $loop_condition           = undef,

  $command_endpoint         = undef,
  $assign                   = undef,
  $ignore                   = undef,


  $display_name             = $name,
  $groups                   = undef,
  $host_name                = undef,
  $vars                     = undef,
  $check_command            = undef,
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

  $service_configs          = $icinga2::server::service_configs,
  $service                  = $icinga2::server::service,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }

  $real_configs = $is_template ? {
    true    => $icinga2::server::template_configs,
    false   => $service_configs,
    default => $service_configs,
  }

  file { "${icinga2::params::confdir}/${real_configs}/${name}.conf":
    ensure  => $real_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('icinga2/objects/service.conf.erb'),
    notify  => Service[$service],
  }
}
