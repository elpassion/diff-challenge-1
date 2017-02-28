# Diff Challenge

## Running your app against spec

1. Modify `spec/endpoints.rb` if you need. **This is the only file you can modify in this repository**. It contains API hostname and hardcoded endpoints. You might want to use different ones.
1. Install gems with `bundle install`
3. Clear your database (tests need database with no data).
3. Launch your app.
3. Run tests with `rspec`. They will hit your API according to configuration in `spec/endpoints.rb` file.
