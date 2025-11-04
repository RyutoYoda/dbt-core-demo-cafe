# dbt-core-demo-cafe🥷

このdbtプロジェクトは、架空のカフェの運営データを分析するためのデータパイプラインを提供します。
<img width="878" alt="スクリーンショット 2025-07-06 17 59 03" src="https://github.com/user-attachments/assets/54404022-df87-4017-be50-9615f0ff4d28" />

## 前提条件

- [Cursor](https://cursor.com/ja), [VS Code](https://code.visualstudio.com/) などのIDE環境が用意されていること
- [uv](https://docs.astral.sh/uv/) がインストールされていること
  ```bash
  # macOS/Linuxの場合
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # またはHomebrewの場合
  brew install uv
  ```
- [cargo-make](https://github.com/sagiegurari/cargo-make) がインストールされていること
  ```bash
  # Homebrewの場合（推奨）
  brew install rust
  brew install cargo-make
  ```

## プロジェクトの目的

このプロジェクトは、カフェの売上、顧客行動、商品パフォーマンス、店舗運営に関する洞察を得ることを目的としています。
具体的には、以下の分析を想定したモデリングを行っています。

- **売上分析**: 日次、月次、年次の売上トレンド、商品カテゴリ別の売上、店舗別の売上などを把握します。
- **顧客分析**: 顧客の購買頻度、初回購入日、最終購入日、顧客満足度などを分析し、顧客セグメンテーションやLTV（顧客生涯価値）の算出に役立てます。
- **商品分析**: 売れ筋商品、死に筋商品、カスタマイズの有無による売上への影響などを分析し、商品戦略の改善に貢献します。
- **店舗分析**: 各店舗の売上貢献度、顧客満足度、注文方法の傾向などを分析し、店舗運営の最適化に役立てます。

## データモデルの概要

このプロジェクトは、以下の3つのレイヤーでデータモデルを構築しています。

1.  **Staging Layer (`stg_`プレフィックス)**:
    - 生データソースから直接データを読み込み、基本的な整形（カラム名のリネーム、データ型の変換など）を行います。
    - 日本語のカラム名を英語に変換し、後続のモデルで扱いやすい形式に統一します。
    - 各ソーステーブルに対応するモデルが存在します。
    - 例: `stg_customers`, `stg_order_items`, `stg_orders`, `stg_products`, `stg_stores`

2.  **Intermediate Layer (`int_`プレフィックス)**:
    - Staging Layerのデータを結合し、より複雑なビジネスロジックや計算を適用します。
    - 最終的な分析モデル（Mart Layer）で利用しやすいように、データを集約・変換します。
    - 例: `int_order_items_joined` (注文、注文明細、商品データを結合し、合計金額を計算)

3.  **Mart Layer (`dim_` / `fct_`プレフィックス)**:
    - 最終的な分析やレポート作成に利用されるディメンション（`dim_`）およびファクト（`fct_`）テーブルです。
    - ディメンションテーブルは、顧客、商品、店舗などの属性情報を提供します。
    - ファクトテーブルは、注文などのイベントや測定値を提供します。
    - 例:
      　ディメンション
        - `dim_customers`: 顧客ごとの初回注文日、最終注文日、注文回数など
        - `dim_products`: 商品の基本情報
        - `dim_stores`: 店舗の基本情報
      　ファクト
        - `fct_orders`: 各注文の合計金額、合計数量、満足度、利用シーンなど

## 各モデルの詳細について

各モデルファイルには、そのモデルの目的、使用しているソース、主要な変換ロジックについてのコメントが記載されています。

## dbtの実行方法(CLI)

### クイックスタート

```bash
# セットアップ
makers sync

# フルビルド（dbt deps + dbt seed + dbt run + dbt test）
makers build
```

### dbtコマンドとmakersコマンドの対応表

| dbtコマンド | makersコマンド | 説明 |
|------------|---------------|------|
| `dbt deps` | `makers dbt deps` | dbtパッケージのインストール |
| `dbt seed` | `makers dbt seed` | シードデータのロード |
| `dbt run` | `makers dbt run` | モデルの実行 |
| `dbt test` | `makers dbt test` | テストの実行 |
| `dbt docs generate` | `makers dbt docs generate` | ドキュメントの生成 |
| `dbt docs serve` | `makers dbt docs serve` | ドキュメントの配信 |
| - | `makers build` | フルビルド（deps + seed + run + test） |
| - | `makers streamlit` | Streamlitアプリの起動 |
| - | `makers duckdb` | DuckDB CLIの起動 |

### 各コマンド

利用可能なコマンド一覧を確認：
```bash
makers help
```

1.  **環境セットアップと依存関係のインストール**:
    ```bash
    makers sync
    ```
    Pythonの仮想環境が作成され、必要なパッケージ（`dbt-duckdb`など）がインストールされます。

2.  **dbtパッケージのインストール**:
    ```bash
    makers dbt deps
    ```

3.  **シードデータのロード**:
    ```bash
    makers dbt seed
    ```

4.  **モデルの実行**:
    ```bash
    makers dbt run
    ```

5.  **テストの実行**:
    ```bash
    makers dbt test
    ```

6.  **フルビルド（deps + seed + run + test）**:
    ```bash
    makers build
    ```

7.  **Streamlitで可視化**:
    ```bash
    makers streamlit
    ```

8.  **ドキュメントの生成と表示**:
    ```bash
    makers dbt docs generate
    makers dbt docs serve
    ```
    ブラウザで `http://localhost:8080` にアクセスすると、生成されたドキュメントを確認できます。

9.  **DuckDBの操作**:
    ```bash
    makers duckdb
    ```
    DuckDB CLIが起動します。以下のようなコマンドが使えます：
    ```sql
    SELECT * FROM fct_orders LIMIT 10;
    .tables  -- テーブルの一覧
    .exit    -- 終了
    ```

10. **クリーンアップ**:
    ```bash
    makers clean
    ```
    仮想環境、dbtの成果物（`target`、`dbt_packages`、`logs`）を削除し、クリーンな状態に戻します。

### 仮想環境をアクティベートして直接実行する場合

makersを使わずにdbtコマンドを直接実行したい場合：

```bash
# 環境のセットアップ
uv sync
source .venv/bin/activate

# dbtコマンドを直接実行
dbt deps   # パッケージのインストール
dbt seed   # シードデータのロード
dbt run    # モデルの実行
dbt test   # テストの実行
```

## 今後の拡張

- さらなる分析要件に応じたMartモデルの追加
- データ品質テストの強化
- パフォーマンス最適化

このプロジェクトが、dbtを使ったデータモデリングの学習に役立つことを願っています。
