{
  "Name": "AWSManagedRulesBotControlRuleSet",
  "Priority": 3,
  "Statement": {
    "ManagedRuleGroupStatement": {
      "VendorName": "AWS",
      "Name": "AWSManagedRulesBotControlRuleSet",
      "ManagedRuleGroupConfigs": [
        {
          "AWSManagedRulesBotControlRuleSet": {
            "InspectionLevel": "TARGETED",
            "EnableMachineLearning": true
          }
        }
      ],
      "RuleActionOverrides": [
        {
          "Name": "CategoryHttpLibrary",
          "ActionToUse": {
            "Challenge": {}
          }
        },
        {
          "Name": "SignalNonBrowserUserAgent",
          "ActionToUse": {
            "Count": {}
          }
        },
        {
          "Name": "TGT_VolumetricIpTokenAbsent",
          "ActionToUse": {
            "Count": {}
          }
        },
        {
          "Name": "TGT_VolumetricSession",
          "ActionToUse": {
            "Count": {}
          }
        }
      ]
    }
  },
  "OverrideAction": {
    "None": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "bot-control-metric"
  }
}