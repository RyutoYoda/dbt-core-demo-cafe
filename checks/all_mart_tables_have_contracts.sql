select
    unique_id,
    name
from {{ info_schema('models') }}
where (name like 'dim_%' or name like 'fct_%')
  and not coalesce(contract_enforced, false)
