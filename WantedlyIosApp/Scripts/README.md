# SwiftLint 設定

このプロジェクトでは、SwiftLintを使用してSwiftコードの静的解析を行っています。

## セットアップ

### 1. SwiftLintのインストール

```bash
brew install swiftlint
```

### 2. 設定ファイル

- `.swiftlint.yml`: SwiftLintの設定ファイル
- `Scripts/swiftlint.sh`: SwiftLintを実行するスクリプト

## 使用方法

### 手動実行

```bash
# プロジェクトルートで実行
./Scripts/swiftlint.sh
```

### Xcodeでの統合

1. Xcodeでプロジェクトを開く
2. ターゲットを選択
3. "Build Phases"タブを開く
4. "+"ボタンをクリックして"New Run Script Phase"を追加
5. 以下のスクリプトを追加：

```bash
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

## 設定内容

### 無効化されたルール
- `trailing_whitespace`: 行末の空白
- `line_length`: 行の長さ
- `function_body_length`: 関数の長さ
- `type_body_length`: 型の長さ
- `file_length`: ファイルの長さ
- `identifier_name`: 識別子の名前

### 有効化されたルール
- `force_unwrapping`: 強制アンラップの検出
- `implicitly_unwrapped_optional`: 暗黙的アンラップオプショナルの検出
- `sorted_imports`: import文のソート

## トラブルシューティング

### SwiftLintが実行できない場合

1. SwiftLintが正しくインストールされているか確認：
   ```bash
   swiftlint version
   ```

2. パスが正しく設定されているか確認：
   ```bash
   which swiftlint
   ```

3. 必要に応じてパスを追加：
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   ```

### エラーが発生する場合

現在のSwiftLintバージョン（0.59.1）で一部のエラーが発生する可能性があります。その場合は、Xcodeのビルドフェーズでの統合を推奨します。 