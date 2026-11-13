#!/bin/sh
# Read-only inspection of codec/counters. Never prints Tuya URLs or credentials.
# Optional: set GO2RTC_API to your local go2rtc API base URL.
set -eu
API="$(printenv GO2RTC_API || echo http://127.0.0.1:1984)"
curl -fsS --max-time 10 "$API/api/streams" | python3 -c '
import json,sys
d=json.load(sys.stdin)
for name,stream in d.items():
    print("Stream:",name)
    for kind in ("producers","consumers"):
        for item in stream.get(kind,[]) or []:
            print(" ",kind,"format:",item.get("format_name"),"protocol:",item.get("protocol"))
            print("  medias:",item.get("medias"))
            for k in ("receivers","senders"):
                for t in item.get(k,[]) or []:
                    c=t.get("codec")
                    c=c.get("codec_name") if isinstance(c,dict) else str(c)
                    print("  ",k,"codec:",c,"bytes:",t.get("bytes"),"packets:",t.get("packets"))
'

