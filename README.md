## Running your app against spec

1. Modify `spec/endpoints.rb` if you need. **This is the only file you can modify in this repository**. It contains API hostname and its endpoints. You might want to use different ones.
1. Install gems with `bundle install`
3. Clear your database, tests need database with no data.
3. Launch your app.
3. Run tests: 
```
bundle exec rspec --format=doc --color
```
They will hit your API according to configuration in `spec/endpoints.rb` file.

Example output:

## Suggested order of making tests pass

1. `spec/requests/user_registration_spec.rb`
1. `spec/requests/groups_management_spec.rb`
    1. create
    1. index 

1. `spec/requests/orders_management_spec.rb`
    1. create
    1. index 
        1. Orders with Group
