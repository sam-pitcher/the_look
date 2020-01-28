include: "*.view"

view: users_gender_info {
  extends: [users]

  dimension: gender {
    type: string
    sql: UPPER(${TABLE}.gender) ;;
  }
}
