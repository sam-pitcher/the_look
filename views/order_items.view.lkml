include: "base.view"

view: order_items {
  sql_table_name: demo_db2.order_items ;;
  drill_fields: [id]

  parameter: sale_price_parameter {
    type: unquoted
    default_value: "sum"
    allowed_value: {
      label: "Sum"
      value: "sum"
    }
    allowed_value: {
      label: "Average"
      value: "avg"
    }
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
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
      WHEN ${sale_price} < {{ bucket_array[i] }} THEN '{{i}}: {{ bucket_array[j] }} < N < {{ bucket_array[i] }}'
    {% endfor %}
    ELSE
      '5: Unknown'
    END ;;
    html: {{ rendered_value | slice: 3, rendered_value.size }} ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: sale_price_with_function {
    type: number
#     sql: {{ sale_price_parameter._parameter_value }}(${sale_price}) ;;
    sql:
    {% if sale_price_parameter._parameter_value == 'sum' %}${total_revenue}
    {% else %}${average_sale_price}
    {% endif %};;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }


}
