view: products {
  sql_table_name: demo_db2.products ;;
  drill_fields: [id]

  parameter: product_hierachy_parameter {
    type: unquoted
    default_value: "brand"
    allowed_value: {
      label: "Brand"
      value: "brand"
    }
    allowed_value: {
      label: "Category"
      value: "category"
    }
    allowed_value: {
      label: "Department"
      value: "department"
    }
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: product_hierachy {
    type: string
    sql:
    {% if product_hierachy_parameter._parameter_value == 'brand' %}${brand}
    {% elsif product_hierachy_parameter._parameter_value == 'category' %}${category}
    {% else %}${department}
    {% endif %}
    ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: brand_logo {
    type: string
    sql: LOWER(REPLACE(REPLACE(${brand}, " ", ""),"'","")) ;;
    html: <img src="https://www.google.com/s2/favicons?domain={{value}}.com"> ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
