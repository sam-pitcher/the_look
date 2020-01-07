include: "*.view"

view: spoke_users {
  extends: [hub_users]
  sql_table_name: demo_db2.users ;;

}
