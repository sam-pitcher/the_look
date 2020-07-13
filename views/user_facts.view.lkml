explore: user_facts {}

view: user_facts {
  derived_table: {
    sql: SELECT
  users.id  AS `users_id`,
  COUNT(*) AS `order_count`
FROM demo_db.order_items  AS order_items
LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id


GROUP BY 1
ORDER BY COUNT(*) DESC ;;

#   sql_trigger_value: SELECT 1 ;;
# datagroup_trigger: the_look_datagroup
# persist_for: "4 days"

  }

  filter: user_id_filter {
    type: string
  }

  dimension: custom_id_group {
    type: string
    sql:
    CASE WHEN
    {% condition user_id_filter %} ${users_id} {% endcondition %}
    THEN 'Target Group' ELSE 'Others' END
    ;;

  }

  parameter: this_is_a_parameter {
    type: unquoted
    allowed_value: {value:"SUM"}
    allowed_value: {value:"MIN"}
    allowed_value: {value:"MAX"}
    allowed_value: {value:"AVG"}
    default_value: "SUM"
  }

  parameter: apply_filtering {
    type: unquoted
    allowed_value: {value:"Yes"}
    allowed_value: {value:"No"}
    default_value: "No"
  }

  parameter: choose_dimension {
    type: unquoted
    allowed_value: {value:"count" label:"Order Count"}
    allowed_value: {value:"id" label: "User ID"}
    default_value: "id"
  }


  filter: this_is_a_filter {
    type: string
  }


  dimension: users_id {
    sql: ${TABLE}.users_id ;;
    type: string
  }

  dimension: order_count {
    sql: ${TABLE}.order_count ;;
    type: number
  }

  dimension: dynamic_dimension {
    type: string
    sql: {% if choose_dimension._parameter_value == 'id' %} ${users_id}
    {% elsif choose_dimension._parameter_value == 'count' %} ${order_count}
    {% else %} NULL {% endif %}
    ;;
  }

  measure: average_order_count {
    type: average
    sql: ${order_count} ;;
  }

  measure: dynamic_measure {
    type: number ## Doesn't do aggregation
    sql: {% parameter this_is_a_parameter %}(${order_count}) ;;
  }

  measure: dynamic_measure_2 {
    type:number
    sql:
    {% if apply_filtering._parameter_value == 'No' %}
    SUM(${order_count})
    {% else %}
    SUM(CASE WHEN ${users_id} > 50 THEN ${order_count} ELSE NULL END)
    {% endif %} ;;
  }

}


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
