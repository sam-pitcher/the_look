include: "base.view"

view: users {
  sql_table_name: demo_db2.users ;;

  extends: [base]
#   drill_fields: [id]

  dimension: id {
    label: "My ID"
  }

  dimension: dummy {
    sql: 'dummy' ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }


  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

#   dimension: state {
#     type: string
#     sql: ${TABLE}.state ;;
#   }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      pending_orders.count,
      user_data.count
    ]
  }
}
