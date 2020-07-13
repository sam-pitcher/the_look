view: germany {
  derived_table: {
    sql:
    SELECT 'Bayern' AS region, 12 AS agg
    UNION ALL
    SELECT 'Baden-Württemberg' AS region, 20 AS agg
    UNION ALL
    SELECT 'Brandenburg' AS region, 18 AS agg
    UNION ALL
    SELECT 'Nordrhein-Westfalen' AS region, 17 AS agg
    UNION ALL
    SELECT 'Niedersachsen' AS region, 19 AS agg
    UNION ALL
    SELECT 'Hamburg' AS region, 30 AS agg
    UNION ALL
    SELECT 'Hessen' AS region, 17 AS agg
    UNION ALL
    SELECT 'Saarland' AS region, 16 AS agg
    UNION ALL
    SELECT 'Sachsen' AS region, 10 AS agg
    UNION ALL
    SELECT 'Thüringen' AS region, 17 AS agg
    UNION ALL
    SELECT 'Sachsen-Anhalt' AS region, 16 AS agg
    ;;
  }

  dimension: region {
    primary_key: yes
  }

  dimension: region_map {
    type: string
    sql: ${TABLE}.region ;;
    map_layer_name: germany
  }

  dimension: agg {
    hidden: yes
    type: number
  }

  measure: total_agg {
    type: sum
    sql: ${agg} ;;
  }

}
