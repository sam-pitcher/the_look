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

  dimension: age_tiers {
    type: tier
    sql: ${age} ;;
    tiers: [0,20,40,60,80]
    style: integer
  }

  parameter: bucket_1 {type: number}

  parameter: bucket_2 {type: number}

  parameter: bucket_3 {type: number}

  parameter: bucket_4 {type: number}

  dimension: bucket_groups {
    sql:
    {% assign bucket_string_1 = bucket_1._parameter_value | append: "," %}
    {% assign bucket_string_2 = bucket_2._parameter_value | append: "," %}
    {% assign bucket_string_3 = bucket_3._parameter_value | append: "," %}
    {% assign bucket_string_4 = bucket_4._parameter_value %}

    {% assign bucket_string = '0,' | append: bucket_string_1 | append: bucket_string_2 | append: bucket_string_3 | append: bucket_string_4 %}
    {% assign bucket_array = bucket_string | remove: ",NULL" | split: "," %}
    {% assign bucket_array_length = bucket_array.size | minus: 1 %}

    CASE
    {% for i in (1..bucket_array_length) %}
    {% assign j = i | minus: 1 %}
      WHEN ${age} <= {{ bucket_array[i] }} THEN '{{i}}: {{ bucket_array[j] }} <= N < {{ bucket_array[i] }}'
    {% endfor %}
    ELSE
      '5: {{ bucket_array.last }} +'
    END ;;
    html: {{ rendered_value | slice: 3, rendered_value.size }} ;;
  }

  parameter: bucket_single {type: string}

  dimension: bucket_groups_single {
    sql:
    {% assign bucket_string = bucket_single._parameter_value %}
    {% assign bucket_array = bucket_string | remove: "'" | prepend: "0," | split: "," %}
    {% assign bucket_array_length = bucket_array.size | minus: 1 %}

    CASE
    {% for i in (1..bucket_array_length) %}
    {% assign j = i | minus: 1 %}
      WHEN ${age} <= {{ bucket_array[i] }} THEN ' {{i}}: {{ bucket_array[j] }} <= N < {{ bucket_array[i] }}'
    {% endfor %}
    ELSE
      '99: {{ bucket_array.last }} +'
    END ;;
    html: {{ rendered_value | slice: 4, rendered_value.size}} ;;
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
