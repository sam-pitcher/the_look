view: period_over_period {

  extension: required

  ######################
  #   DATE SELECTIONS   #
  ######################

  filter: current_date_range {
    type: date
    view_label: "Period over Period"
    label: "Date Range"
    description: "Select the date range you are interested in using this filter, can be used by itself. Make sure any filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
    convert_tz: yes
  }

  parameter: compare_to {
    view_label: "Period over Period"
    description: "Choose the period you would like to compare to. Must be used with Current Date Range filter"
    label: "Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "Quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "Year"
    }
    default_value: "Period"
  }

  dimension_group: pop_no_tz {
    type: time
    timeframes: [
      raw,
      time,
      date
    ]
    # sql: ${TABLE}.itemdate ;;
    convert_tz: no
  }

  ###############
  #   PERIODS   #
  ###############

  dimension_group: in_period { #change name to in_period as it's a dimension group
    view_label: "Period over Period"
    type: duration
    intervals: [day]
    description: "Gives the number of days in the current period date range"
    sql_start: {% date_start current_date_range %} ;;
    sql_end: {% date_end current_date_range %} ;;
  }

  dimension: period_1_start {
    view_label: "Period over Period"
    type: date_time
    sql: {% date_start current_date_range %} ;;
    convert_tz: no
  }

  dimension: period_1_end {
    type: date_time
    view_label: "Period over Period"
    sql: {% date_end current_date_range %} ;;
    convert_tz: no
  }

  dimension: period_2_start {
    view_label: "Period over Period"
    description: "Calculates the start of the previous period"
    type: date_raw
    sql:
    CAST(
    {% if compare_to._parameter_value == "Period" %}
      TIMESTAMP_SUB(CAST(${period_1_start} AS TIMESTAMP) , INTERVAL ${days_in_period} DAY)
    {% else %}
      TIMESTAMP(DATETIME_SUB(DATETIME(CAST(${period_1_start} AS TIMESTAMP)) , INTERVAL 1 {% parameter compare_to %}))
    {% endif %}
    AS TIMESTAMP) ;;
  }

  dimension: period_2_end {
    view_label: "Period over Period"
    description: "Calculates the end of the previous period"
    type: date_raw
    sql:
    CAST(
    {% if compare_to._parameter_value == "Period" %}
      TIMESTAMP_SUB(CAST(${period_1_start} AS TIMESTAMP), INTERVAL 0 DAY)
    {% else %}
      TIMESTAMP(DATETIME_SUB(DATETIME_SUB(DATETIME(CAST(${period_1_end} AS TIMESTAMP)), INTERVAL 1 DAY), INTERVAL 1 {% parameter compare_to %}))
    {% endif %}
    AS TIMESTAMP) ;;
  }

  dimension: day_in_period {
    # hidden: yes
    description: "Gives the number of days since the start of each periods. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
      CASE

        WHEN ${pop_no_tz_raw} between CAST(${period_1_start} AS TIMESTAMP) and CAST(${period_1_end} AS TIMESTAMP)
        THEN TIMESTAMP_DIFF(${pop_no_tz_raw},CAST(${period_1_start} AS TIMESTAMP),DAY)+1

        WHEN ${pop_no_tz_raw} between ${period_2_start} and ${period_2_end}
        THEN TIMESTAMP_DIFF(${pop_no_tz_raw}, ${period_2_start},DAY)+1

      END

    {% else %} NULL
    {% endif %} ;;
  }

  ##########################
  #   HIDDEN DIMESNSIONS   #
  ##########################

  dimension: period {
    view_label: "Period over Period"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
#     order_by_field: order_for_period
    sql:
       {% if current_date_range._is_filtered %}
         CASE
           WHEN ${pop_no_tz_raw} between CAST(${period_1_start} AS TIMESTAMP) and CAST(${period_1_end} AS TIMESTAMP)
           THEN 'This {% parameter compare_to %}'
           WHEN ${pop_no_tz_raw} between ${period_2_start} and ${period_2_end}
           THEN 'Last {% parameter compare_to %}'
         END
       {% else %}
         NULL
       {% endif %}
       ;;
  }

  ##########################
  #   DIMENSIONS TO PLOT   #
  ##########################

  dimension_group: date_in_period {
    description: "Use this as your date dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    sql: TIMESTAMP_ADD(CAST(${period_1_start} AS TIMESTAMP),INTERVAL (${day_in_period}-1) DAY) ;;
    view_label: "Period over Period"
    timeframes: [date, week, month, quarter, year]
  }

}
