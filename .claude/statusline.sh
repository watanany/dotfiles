#!/bin/sh
# Claude Code statusLine: コンテキスト使用率と /usage 相当のプラン使用率・リセット時刻を表示する
# 例: ctx 31% │ 5h ■■□□□□□□□□ 23% ↻12:15 │ 週 ■■■■□□□□□□ 41% ↻10/29 10:00
# 80% 以上は黄、90% 以上は赤で表示する
jq -r '
  def bar: ([. / 10 | floor, 10] | min) as $n | (("■" * $n) // "") + (("□" * (10 - $n)) // "");
  def paint($p): if $p >= 90 then "\u001b[31m\(.)\u001b[0m" elif $p >= 80 then "\u001b[33m\(.)\u001b[0m" else . end;
  [ (.context_window.used_percentage | select(.) | . as $p | "ctx \(floor)%" | paint($p)),
    (.rate_limits.five_hour | select(.) | .used_percentage as $p
      | "\("5h \($p | bar) \($p | floor)%" | paint($p)) ↻\(.resets_at | strflocaltime("%H:%M"))"),
    (.rate_limits.seven_day | select(.) | .used_percentage as $p
      | "\("週 \($p | bar) \($p | floor)%" | paint($p)) ↻\(.resets_at | strflocaltime("%m/%d %H:%M"))") ]
  | join(" │ ")'
