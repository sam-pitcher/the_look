view: products {
  sql_table_name: demo_db2.products ;;
#   drill_fields: [id]

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
    can_filter: no
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
    link: {
      url: "https://www.google.com/search?q={{value}}"
      label: "Google Search for {{value}}"
    }
#     html: My brand is: {{value}} and it's cat is {{category._value}} ;;
  }

  dimension: brand_logo {
    type: string
    sql: LOWER(REPLACE(REPLACE(${brand}, " ", ""),"'","")) ;;
    html: <img src="https://www.google.com/s2/favicons?domain={{value}}.com"> ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [id, department]
  }

  dimension: department {
    suggestable: yes
#     bypass_suggest_restrictions: yes
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
#     can_filter: no
  }

  dimension: item_name_liquid {
    type: string
    sql: ${TABLE}.item_name ;;
    html:
    {% assign my_array = value | split: ' ' %}
    {% for item in my_array %}
    {{ item | capitalize }}
    {% endfor %}
    ;;
  }
#   ['Kasper', 'Eternal']

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: rank_liquid {
    type: number
    sql: ${TABLE}.rank ;;
    html:
    {% assign mod_value = value | modulo: 2 %}
    {% if mod_value == 1 %}Odd{% else %}Even{% endif %};;
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
