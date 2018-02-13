#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with logshipping](#setup)
    * [What logshipping affects](#what-logshipping-affects)
    * [Setup Requirements](#setup-requirements)
    * [Beginning with logshipping](#beginning-with-logshipping)
3. [Usage Example](#usage-example)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Configure the Claranet AWS Elasticsearch Logshipping solution, Filebeat->LogZoom->S3.

It uses https://forge.puppet.com/pcfens/filebeat under the hood to install and partially configure Filebeat.

## Setup

### What logshipping affects

- Installs Filebeat
- Installs LogZoom (expects our fork)
- Installs JournalBeat
- Configures Filebeat and JournalBeat to output to LogZoom

### Setup Requirements

You must have Filebeat and our LogZoom fork either pre-installed or available from your project's repos.
By default we assume you have Filebeat 6 or above.
You must configure a destination S3 bucket for logs to be sent to, and instance IAM privileges to allow writing to this

### Beginning with logshipping

- Include this module
- In your hiera config define `filebeat::prospectors`- see https://forge.puppet.com/pcfens/filebeat#define-filebeatprospector
- In hiera define `logshipping::output_s3_bucket` and `logshipping::output_s3_prefix`
- Set `logshipper::output_s3_region` if the destination bucket is not in `eu-west-1`
- If desired, add custom journalbeat fields

## Usage Example

In a hiera profile:

```yaml
classes:
  - logshipping

logshipping::output_s3_bucket: customername-logshipping
logshipping::output_s3_prefix: "%{::envname}-${::envtype}"
logshipping::journalbeat_fields:
  account_name: "%{::account_name}" # Assumes we have a custom account_name fact
  envtype: "%{::envtype}" # Assumes we have a custom envtype fact
  envname: "%{::envname}" # Assumes we have a custom envname fact
  instance_id: "%{::ec2_metadata.instance-id}"
  availability_zone: "%{::ec2_metadata.placement.availability-zone}"
filebeat::prospectors:
  varnish:
    paths:
      - /var/log/varnish/varnishncsa.log
    fields:
      account_name: "%{::account_name}" # Assumes we have a custom account_name fact
      envtype: "%{::envtype}" # Assumes we have a custom envtype fact
      envname: "%{::envname}" # Assumes we have a custom envname fact
      instance_id: "%{::ec2_metadata.instance-id}"
      availability_zone: "%{::ec2_metadata.placement.availability-zone}"
```

## Limitations

Only RHEL derived distros are currently supported.

This module currently only configures filebeat input.
It would make sense for [winlogbeat](https://www.elastic.co/products/beats/winlogbeat) to be added for our win32 friends.

By default, JournalBeat will not ship journal entries from itself or logzoom.
