# == Class logshipping::install
#
# This class is called from logshipping for install.
#
class logshipping::install {

  package { $::logshipping::logzoom_package_name:
    ensure => present,
  }
}
