{% test date_less_than_equal_to_today_generic(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} <= current_date()

{% endtest%}