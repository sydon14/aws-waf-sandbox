{
  "Name": "AWSManagedRulesKnownBadInputsRuleSet",
  "Priority": 20,
  "OverrideAction": {
    "None": {}
  },
  "Statement": {
    "ManagedRuleGroupStatement": {
      "VendorName": "AWS",
      "Name": "AWSManagedRulesKnownBadInputsRuleSet"
    }
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "KnownBadInputs"
  }
}