connection: "thelook"

# include all the views
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"
# include: ".germany.json"

datagroup: the_look_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hours"
}

persist_with: the_look_default_datagroup

access_grant: groups_that_have_access {
  allowed_values: ["finance"]
  user_attribute: team
}

map_layer: germany {
  file: "/germany.json"
  format: topojson
  property_key: "NAME_1"
}

##############################
##         EXPLORES         ##
##############################

explore: users {}

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

#############################
##         EXTENDS         ##
#############################

explore: orders {
  view_name: orders
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders_extended {
  extends: [orders]

  join: order_items {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

###################################
##         ACCESS FILTER         ##
###################################

explore: order_items_with_access_filter {
  extends: [order_items]
  from: order_items
  view_name: order_items
  access_filter: {
    user_attribute: brand
    field: products.brand
  }
}

###################################
##         DATA TESTS         ##
###################################

test: order_data_exists {
  explore_source: order_items {
    column: count {}
    }
  assert: count_greater_than_zero {
    expression: ${order_items.count} > 0 ;;
  }
}
