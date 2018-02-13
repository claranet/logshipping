# Class: logshipping
# ===========================
#
# Full description of class logshipping here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class logshipping (
  String $logzoom_package_name = 'logzoom',
  String $logzoom_service_name = 'logzoom',
  Integer $logzoom_listen_port = 10200,
  String $logzoom_config_file = '/etc/logzoom.yaml',
  String $journalbeat_package_name = 'journalbeat',
  String $journalbeat_service_name = 'journalbeat',
  String $journalbeat_config_file = '/etc/journalbeat/journalbeat.yml',
  Hash $journalbeat_fields = {},
  String $filebeat_major_version = '6',
  String $output_s3_region = 'eu-west-1',
  String $output_s3_bucket = undef,
  String $output_s3_prefix = undef,
){

  # validate parameters here

  class { '::logshipping::install': }
  -> class { '::logshipping::config': }
  ~> class { '::logshipping::service': }
  -> Class['::logshipping']


  class { '::filebeat':
    manage_repo   => false,
    major_version => $filebeat_major_version,
    outputs       => {
      'logstash' =>  {
        'hosts'             => [ "localhost:${logzoom_listen_port}" ],
        'compression_level' =>  1,
        'ssl.enabled'       => false,
      }
    }
  }
}
