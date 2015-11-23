define icinga2::plugin (
  $ensure,

  $remote                   = undef,

  $contribdir               = $icinga2::server::plugincontribdir,
) {

  $real_ensure = $ensure ? {
    /(true|present|file)/ => 'file',
    /(false|absent)/      => 'absent',
    default               => 'file',
  }
}
