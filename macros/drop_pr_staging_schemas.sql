{%- macro drop_pr_schemas() -%}
  {% set pr_schema = "PR_" ~ var('schema_id') %}

  {{ log("Dropping PR staging schemas for schema: " ~ pr_schema, info=true) }}

  {% set drop_query = 'drop schema if exists ' ~ target.database ~ '.' ~ pr_schema ~ ' cascade' %}

  {% do run_query(drop_query) %}
  {{ log("Schema " ~ pr_schema ~ " dropped successfully", info=true) }}
{%- endmacro -%}