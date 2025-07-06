import streamlit as st
import duckdb
import pandas as pd

# DuckDBデータベースファイルのパス
DB_PATH = "./dbt_core_demo_cafe.duckdb"

st.set_page_config(layout="wide")
st.title("架空カフェ分析ダッシュボード☕️")

@st.cache_data
def load_data(table_name):
    conn = duckdb.connect(database=DB_PATH, read_only=True)
    df = conn.execute(f"SELECT * FROM {table_name}").fetchdf()
    conn.close()
    return df

# fct_ordersの可視化
st.header("売上データ (fct_orders)")
fct_orders_df = load_data("fct_orders")
dim_stores_df = load_data("dim_stores")

# fct_ordersとdim_storesを結合して店舗名を追加
fct_orders_df = pd.merge(fct_orders_df, dim_stores_df[['store_key', 'store_name']], on='store_key', how='left')

st.dataframe(fct_orders_df)

if not fct_orders_df.empty:
    st.subheader("日別売上推移")
    daily_sales = fct_orders_df.groupby(fct_orders_df["ordered_at"].dt.date)["total_price"].sum().reset_index()
    daily_sales.columns = ["order_date", "total_price"]
    st.line_chart(daily_sales.set_index("order_date"))

    st.subheader("店舗別売上")
    store_sales = fct_orders_df.groupby("store_name")["total_price"].sum().reset_index()
    st.bar_chart(store_sales.set_index("store_name"))

# dim_customersの可視化
st.header("顧客データ (dim_customers)")
dim_customers_df = load_data("dim_customers")
st.dataframe(dim_customers_df)

if not dim_customers_df.empty:
    st.subheader("顧客数")
    st.metric(label="総顧客数", value=len(dim_customers_df))

st.markdown("---")
st.info("このダッシュボードはdbtとStreamlitで構築されています。")
