{
  "Name": "dbhds-STAR-CustomUserAgentHeader-TGT_VolumetricSession-exception",
  "Priority": 8,
  "Statement": {
    "AndStatement": {
      "Statements": [
        {
          "LabelMatchStatement": {
            "Scope": "NAMESPACE",
            "Key": "awswaf:managed:aws:bot-control:targeted:aggregate:volumetric:session:"
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
    "Captcha": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "dbhds-STAR-CustomUserAgentHeader-TGT_VolumetricSession-exception"
  }
}