{
  "Name": "dbhds-STAR-CustomUserAgentHeader-TGT_VolumetricIpTokenAbsent-exception",
  "Priority": 7,
  "Statement": {
    "AndStatement": {
      "Statements": [
        {
          "LabelMatchStatement": {
            "Scope": "LABEL",
            "Key": "awswaf:managed:aws:bot-control:targeted:aggregate:volumetric:ip:token_absent"
          }
        },
        {
          "NotStatement": {
            "Statement": {
              "RegexMatchStatement": {
                "RegexString": "dbhds-.*-useragent",
                "FieldToMatch": {
                  "Headers": {
                    "MatchPattern": {
                      "IncludedHeaders": [
                        "User-Agent",
                        "X-DBHDS-User-Agent"
                      ]
                    },
                    "MatchScope": "ALL",
                    "OversizeHandling": "CONTINUE"
                  }
                },
                "TextTransformations": [
                  {
                    "Priority": 0,
                    "Type": "NONE"
                  }
                ]
              }
            }
          }
        }
      ]
    }
  },
  "Action": {
    "Challenge": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "dbhds-STAR-CustomUserAgentHeader-TGT_VolumetricIpTokenAbsent-exception"
  },
  "ChallengeConfig": {
    "ImmunityTimeProperty": {
      "ImmunityTime": 3600
    }
  }
}