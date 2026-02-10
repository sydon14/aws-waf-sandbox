{
  "Name": "VSP-AllowDocuSignIPs",
  "Priority": 1,
  "Statement": {
    "IpSetReferenceStatement": {
      "ARN": "${ip_set_arn}"
    }
  },
  "Action": {
    "Allow": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudwatchMetricsEnabled": true,
    "MetricName": "allowed-ip-metric"
  }
}