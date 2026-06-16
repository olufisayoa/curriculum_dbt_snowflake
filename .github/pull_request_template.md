# Pull Request (PR) Template

## Pull Request Title
The title should succinctly explain the changes. For example, "Add test case for dim_cohort model"

## Description
Provide a brief description of the changes your pull request makes. Explain the problem it solves or the feature it adds to the project.

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Data model change (schema, table, or column modification)
- [ ] Documentation update


## Changes Made
Provide a detailed list of changes

- 
- 
- 

### Models Affected
List any models created, modified, or removed

### Tests Added/Modified
List any new or updated tests

### Documentation
Note any updates to dbt YAML documentation

## Testing & Validation
Describe how the changes were tested

- [ ] Local `dbt run` executed successfully
- [ ] Local `dbt test` passed
- [ ] All tests pass in CI/CD pipeline
- [ ] Data freshness and quality checks passed
- [ ] Manual testing completed (if applicable)

## Screenshots or Data Examples
If applicable, include examples of the output or data changes

## Checklist
Ensure all items are completed before submitting 

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated relevant documentation (models, macros, README)
- [ ] My changes generate no new warnings or errors
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] I have updated the dbt project version (if breaking change)


