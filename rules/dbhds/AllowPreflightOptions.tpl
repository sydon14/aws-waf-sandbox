{
  "Name": "AllowPreflightOPTIONS",
  "Priority": 1,
  "Statement": {
    "AndStatement": {
      "Statements": [
        {
          "RegexMatchStatement": {
            "RegexString": ".*appst.dbhds.virginia.gov.*|.*appsd.dbhds.virginia.gov.*|.*appsu.dbhds.virginia.gov.*|.*apps.dbhds.virginia.gov.*|.*biapid.dbhds.virginia.gov.*|.*biapit.dbhds.virginia.gov.*|.*biapip.dbhds.virginia.gov.*|.*biapiu.dbhds.virginia.gov.*",
            "FieldToMatch": {
              "Headers": {
                "MatchPattern": {
                  "IncludedHeaders": [
                    "Host"
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
        },
        {
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
        }
      ]
    }
  },
  "Action": {
    "Allow": {}
  },
  "VisibilityConfig": {
    "SampledRequestsEnabled": true,
    "CloudWatchMetricsEnabled": true,
    "MetricName": "AllowPreflightOPTIONS"
  }
}