#!/bin/bash

echo "🤖 ローカルAIレビューを開始します..."

# まだPushされていないコミットの差分を取得する
DIFF=$(git diff @{u}..HEAD 2>/dev/null || git diff HEAD~1..HEAD)

if [ -z "$DIFF" ]; then
  echo "✅ レビューする新しい変更がありません。Pushを続行します。"
  exit 0
fi

# claudeコマンドが使えるか確認
if ! command -v claude &> /dev/null; then
  echo "⚠️  claudeコマンドが見つかりません。レビューをスキップしてPushを続行します。"
  echo "   インストール: npm install -g @anthropic-ai/claude-code"
  exit 0
fi

echo "🔍 Claudeに差分をチェックさせています..."

PROMPT="あなたはシニアエンジニアです。以下のコード差分をレビューしてください。

【レビュー方針】
- 変数名の命名規則・フォーマットなどのnitsは絶対に指摘しない
- データ処理ロジックの欠陥、ゼロ除算・空データなどのエッジケース、パフォーマンスのボトルネックを重点的に確認
- 致命的なバグや重大な問題があれば最後に「REJECT」と出力
- 問題がなければ最後に「PASS」と出力
- 回答は日本語で

## 差分
\`\`\`
$DIFF
\`\`\`"

RESULT=$(claude --print "$PROMPT" 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "⚠️  Claudeの実行に失敗しました。レビューをスキップしてPushを続行します。"
  exit 0
fi

echo ""
echo "📋 AIレビュー結果:"
echo "─────────────────────────────────────"
echo "$RESULT"
echo "─────────────────────────────────────"
echo ""

if [[ "$RESULT" == *"REJECT"* ]]; then
  echo "❌ 【AIレビュー失敗】致命的なバグや懸念点が見つかりました！"
  echo "修正してから再度Pushしてください。"
  exit 1
else
  echo "✅ 【AIレビュー通過】問題ありませんでした。Pushを続行します！"
  exit 0
fi
