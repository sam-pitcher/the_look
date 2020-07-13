include: "base.view"

view: users {
  sql_table_name: demo_db2.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    link: {
      url: "/dashboards/20?User ID={{ value }}"
      label: "Look up User ID #{{value}}"
    }

#     link: {
#       url: "/dashboards/4?User%20ID={{value}}" ## Liquid
#       label: "Look up user {{value}}"
#     }
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
    drill_fields: [state]
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
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

  dimension: gender {
    type: string
    sql: CASE WHEN ${TABLE}.gender = 'm' THEN 'Male' ELSE 'Female' END ;;
  }
  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, city, state, country]
  }

}
