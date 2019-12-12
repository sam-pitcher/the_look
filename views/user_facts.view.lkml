# explore: user_facts {}
#
# view: user_facts {
#   derived_table: {
#     sql: SELECT
#   users.id  AS `users_id`,
#   COUNT(*) AS `order_count`
# FROM demo_db.order_items  AS order_items
# LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
# LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id
#
# GROUP BY 1
# ORDER BY COUNT(*) DESC ;;
#
#   sql_trigger_value: SELECT 1 ;;
# # datagroup_trigger: the_look_datagroup
# # persist_for: "4 days"
#
#   }
#
#
#
#   dimension: users_id {
#     sql: ${TABLE}.users_id ;;
#     type: string
#   }
#
#   dimension: order_count {
#     sql: ${TABLE}.order_count ;;
#     type: number
#   }
#
#   measure: average_order_count {
#     type: average
#     sql: ${order_count} ;;
#   }
#
# }
#
#
# view: add_a_unique_name_1575980531 {
#   derived_table: {
#     explore_source: order_items {
#       column: id { field: users.id }
#       column: count { field:order_items.count }
#     }
#   }
#   dimension: id {
#     type: number
#   }
#   dimension: count {
#     type: number
#   }
#   measure: average_order_count {
#     type: average
#     sql: ${count} ;;
#   }
# }
