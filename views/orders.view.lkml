include: "../views_common/period_over_period.view"

view: orders {
  sql_table_name: demo_db2.orders ;;

  extends: [period_over_period]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: ["segment_anonymous_id"]
  }

  dimension_group: pop {
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      fiscal_year
    ]
    sql: ${TABLE}.created_at ;;
  }

  filter: status_filter {
    required_access_grants: [groups_that_have_access]
    sql: {% condition status_filter %}${status}{% endcondition %} ;;
    suggest_dimension: orders.status
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    tags: ["user_id", "email", "segment_anonymous_id"]
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }


  measure: running_count {
    type: running_total
    sql: ${count} ;;
  }
}
