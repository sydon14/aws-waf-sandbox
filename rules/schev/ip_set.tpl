{
  "Name": "BlockBadIP",
  "Priority": 5,
  "Action": {
    "Block": {}
  },
  "Statement": {
    "IPSetReferenceStatement": {
      "ARN": "${ip_set_arn}"
    }
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "BlockBadIP"
  }
}