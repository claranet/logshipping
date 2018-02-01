# == Class logshipping::config
#
# This class is called from logshipping for service config.
#
class logshipping::config {
  file { $::logshipping::logzoom_config_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content =>  template('logshipping/logzoom.yaml.erb'),
  }
}
