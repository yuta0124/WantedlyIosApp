#!/bin/bash

# SwiftLint実行スクリプト

# プロジェクトのルートディレクトリに移動
cd "$(dirname "$0")/.."

# SwiftLintがインストールされているかチェック
if ! command -v swiftlint &> /dev/null; then
    echo "SwiftLint is not installed. Please install it with: brew install swiftlint"
    exit 1
fi

# SwiftLintを実行
echo "Running SwiftLint..."
swiftlint lint --reporter xcode

# 終了コードを取得
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "✅ SwiftLint passed successfully!"
else
    echo "❌ SwiftLint found issues. Please fix them."
fi

exit $exit_code 