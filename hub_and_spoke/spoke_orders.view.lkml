include: "*.view"

view: spoke_orders {
  extends: [hub_orders]
  sql_table_name: demo_db2.orders ;;
}
