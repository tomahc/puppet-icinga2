class icinga2::globals (
  $confdir                                = '/etc/icinga2',
  
  $include_files                          = ['constants.conf', 'zones.conf', 'features-enabled/*.conf'],
  $include_directories                    = ['repository.d', 'conf.d']

) {
}
