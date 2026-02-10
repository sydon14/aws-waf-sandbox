{
  "Name": "rule-1",
  "Priority": 2,
  "Statement": {
    "ManagedRuleGroupStatement": {
      "VendorName": "AWS",
      "Name": "AWSManagedRulesCommonRuleSet",
      "ScopeDownStatement": {
        "GeoMatchStatement": {
          "CountryCodes": [
            "US"
          ]
        }
      },
      "RuleActionOverrides": [
        {
          "Name": "SizeRestrictions_QUERYSTRING",
          "ActionToUse": {
            "Count": {}
          }
        },
        {
          "Name": "NoUserAgent_HEADER",
          "ActionToUse": {
            "Count": {}
          }
        }
      ]
    }
  },
  "OverrideAction": {
    "Count": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "common-rule-set-metric"
  }
}