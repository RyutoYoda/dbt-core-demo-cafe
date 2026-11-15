select
    unique_id,
    name
from {{ info_schema('models') }}
where description is null
   or trim(description) = ''
