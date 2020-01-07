connection: "thelook"

# include all the views
include: "*.view"

datagroup: the_look_default_datagroup {
  max_cache_age: "4 hours"
}

persist_with: the_look_default_datagroup

explore: spoke_orders {
  join: spoke_users {
    type: left_outer
    sql_on: ${spoke_orders.user_id} = ${spoke_users.id} ;;
    relationship: many_to_one
  }
}
