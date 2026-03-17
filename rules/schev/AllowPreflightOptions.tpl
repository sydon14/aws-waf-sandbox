{
  "Name": "AllowPreflightOPTIONS",
  "Priority": 1,
  "Action": {
    "Allow": {}
  },
  "Statement": {
    "ByteMatchStatement": {
      "SearchString": "OPTIONS",
      "FieldToMatch": {
        "Method": {}
      },
      "TextTransformations": [
        {
          "Priority": 0,
          "Type": "NONE"
        }
      ],
      "PositionalConstraint": "EXACTLY"
    }
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "AllowPreflightOPTIONS"
  }
}