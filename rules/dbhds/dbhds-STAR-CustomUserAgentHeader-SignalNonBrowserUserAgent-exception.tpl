{
  "Name": "dbhds-STAR-CustomUserAgentHeader-SignalNonBrowserUserAgent-exception",
  "Priority": 6,
  "Statement": {
    "AndStatement": {
      "Statements": [
        {
          "LabelMatchStatement": {
            "Scope": "LABEL",
            "Key": "awswaf:managed:aws:bot-control:signal:non_browser_user_agent"
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
    "Block": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "dbhds-STAR-CustomUserAgentHeader-SignalNonBrowserUserAgent-exception"
  }
}