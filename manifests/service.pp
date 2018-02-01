# == Class logshipping::service
#
# This class is meant to be called from logshipping.
# It ensure the service is running.
#
class logshipping::service {

  service { $::logshipping::logzoom_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
