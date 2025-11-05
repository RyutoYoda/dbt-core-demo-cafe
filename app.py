import streamlit as st
import duckdb
import polars as pl

# --- データベース接続とデータ読み込み --- #
DB_PATH = "./dbt_core_demo_cafe.duckdb"

@st.cache_data
def load_data(query):
    """dbtが生成したDuckDBデータベースに接続し、指定されたクエリを実行してPolars DataFrameを返す"""
    conn = duckdb.connect(database=DB_PATH, read_only=True)
    df = conn.execute(query).pl()
    conn.close()
    return df

# --- Streamlit UIの設定 --- #
st.set_page_config(layout="wide")
st.title("架空カフェ売上分析ダッシュボード☕️")
st.info("このダッシュボードは、dbtで構築された単一のスタースキーマ（`fct_order_items`と3つの`dim_*`テーブル）を可視化したものです。")

# --- データマートの読み込み --- #
# ファクトテーブルと、グラフ作成に必要なディメンションテーブルを読み込む
fct_df = load_data("SELECT * FROM fct_order_items")
dim_stores_df = load_data("SELECT store_key, store_name FROM dim_stores")
dim_products_df = load_data("SELECT product_key, category FROM dim_products")

# --- グラフ作成のためのデータ準備 --- #

# 1. 日別売上 (Daily Sales)
# ファクトテーブルの`ordered_at`を日付に丸め、`line_item_total_price`を合計する
daily_sales = (
    fct_df
    .with_columns(
        pl.col("ordered_at").cast(pl.Date).alias("ordered_date")
    )
    .group_by("ordered_date")
    .agg(pl.col("line_item_total_price").sum())
    .sort("ordered_date")
)

# 2. 店舗別売上 (Sales by Store)
# ファクトテーブルと店舗ディメンションを`store_key`でマージ（結合）する
store_sales = (
    fct_df
    .join(dim_stores_df, on="store_key")
    .group_by("store_name")
    .agg(pl.col("line_item_total_price").sum())
    .sort("line_item_total_price", descending=True)
)

# 3. 商品カテゴリ別売上 (Sales by Product Category)
# ファクトテーブルと商品ディメンションを`product_key`でマージ（結合）する
category_sales = (
    fct_df
    .join(dim_products_df, on="product_key")
    .group_by("category")
    .agg(pl.col("line_item_total_price").sum())
    .sort("line_item_total_price", descending=True)
)


# --- グラフの表示 --- #

st.header("主要KPI")

# 2列レイアウト
col1, col2 = st.columns(2)

with col1:
    st.subheader("日別売上推移")
    st.line_chart(daily_sales.to_pandas().set_index('ordered_date'), color="#0072B2")

with col2:
    st.subheader("店舗別売上")
    st.bar_chart(store_sales.to_pandas().set_index('store_name'), color="#009E73")

st.subheader("商品カテゴリ別売上")
st.bar_chart(category_sales.to_pandas().set_index('category'), color="#E69F00")
