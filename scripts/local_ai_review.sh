#!/bin/bash

echo "🤖 ローカルAIレビューを開始します..."

# まだPushされていないコミットの差分を取得する
DIFF=$(git diff @{u}..HEAD 2>/dev/null || git diff HEAD~1..HEAD)

if [ -z "$DIFF" ]; then
  echo "✅ レビューする新しい変更がありません。Pushを続行します。"
  exit 0
fi

# ---------------------------------------------------------
# 【ここにClaude CodeなどのAIを呼び出す処理を書きます】
# ※ 以下はイメージです。実際のClaude CodeのCLIコマンドに置き換えます。
# ---------------------------------------------------------
echo "🔍 Claudeに差分をチェックさせています..."

# 例: Claudeに差分を渡し、致命的なエラーがあれば "REJECT" を返させるプロンプト
# RESULT=$(claude --print "以下の変更をレビューして。nitsは無視。ヤバいバグがあれば'REJECT'、OKなら'PASS'と出力して。差分: $DIFF")

# 今回はテスト用に「わざと失敗（エラー）にさせる」か「成功させる」かをシミュレーションします
# ※ テストが済んだら、ここを本物のAIコマンドに書き換えます
RESULT="PASS" # ここを "REJECT" に書き換えるとPushがブロックされます

if [[ "$RESULT" == *"REJECT"* ]]; then
  echo "❌ 【AIレビュー失敗】致命的なバグや懸念点が見つかりました！"
  echo "修正してから再度Pushしてください。"
  exit 1  # exit 1 で終了すると、GitはPushを中止（ブロック）します
else
  echo "✅ 【AIレビュー通過】問題ありませんでした。Pushを続行します！"
  exit 0  # exit 0 で終了すると、GitはそのままPushを実行します
fi