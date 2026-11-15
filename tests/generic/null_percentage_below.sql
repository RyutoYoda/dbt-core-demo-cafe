{% test null_percentage_below(model, column_name, max_percentage) %}

with null_profile as (

    select
        count(*) as row_count,
        sum(case when {{ column_name }} is null then 1 else 0 end) as null_count
    from {{ model }}

)

select
    row_count,
    null_count,
    100.0 * null_count / nullif(row_count, 0) as null_percentage
from null_profile
where row_count > 0
  and 100.0 * null_count / nullif(row_count, 0) > {{ max_percentage }}

{% endtest %}
