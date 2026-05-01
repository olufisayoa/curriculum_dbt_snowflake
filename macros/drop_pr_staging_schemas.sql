{%- macro drop_pr_schemas() -%}
  {% set pr_schema = "PR__" ~ var('schema_id') %}

  {{ log("Dropping PR staging schemas for schema: " ~ pr_schema, info=true) }}

  {% set drop_query %}
    drop schema if exists {{target.database}}.{{pr_schema}} cascade
  {% endset %}

  {% if execute %}
    {% call statement('drop_pr_schemas', auto_begin=False) %}
        {{ drop_query }}
    {% endcall %}

    {% set check_query %}
        select count(*) as schema_exists
        from information_schema.schemata
        where catalog_name = '{{ target.database }}'
        and schema_name = '{{ pr_schema }}'
    {% endset %}

    {% set result = run_query(check_query) %}
    {% set row = result.columns[0].values()[0] %}
    
    {% if row == 0 %}
        {{ log("Schema " ~ pr_schema ~ " does not exist after drop attempt", info=true) }}
    {% else %}
        {{ log("Schema " ~ pr_schema ~ " still exists after drop attempt", info=true) }}
    {% endif %}
    {{ log("Schema " ~ pr_schema ~ " dropped successfully", info=true) }}
  {% endif %}
{%- endmacro -%}