### Overview
This is a **Diff Challenge** repository. If you don't know what **Diff Challenge** is 
(and you don't, because this is the first one in existence!), 
read [this](https://github.com/elpassion/diff-challenge-1/wiki/Diff-Challenge) first.

#### First part (Codebase Part)
From the technical point of view, your task is to build an API which will pass the tests from this repository. From the business point of view, your task is to build an app for group food ordering.

There are 7 endpoints to implement which can be grouped in three categories:
- User registration and authentication (very basic).
- Creating Groups, i.e. collection of Users which can order food from a restaurant.
- Creating Orders. Order can be assigned to an existing Group or to a collection of individuals created ad hoc by entering their emails.

You have 14 days to submit your solution.

#### Second part (Diff Part)
After the Codebase Part all participants who submitted their solution will receive a new specification in form of updated tests. 
Diff created to meet these requirements will be evaluated.
It will show us how easy your code can adapt to new business needs. 
For example, a few small changes in a few files are probably better than huge changes in many files.  

**Notes** 

- This is not about creating fully functional app. You'll implement very limited and simple features, so don't be surprise by the fact that there are no tests for validations or that authentication is very basic.
- This is the first iteration of Diff Challenge **ever**. Please be patient, share your feedback, and most of all don't treat final results very seriously - we are not even sure how to measure diffs yet! 

### Steps

1. Install requirements:
    - Ruby 2.3.3.
    - Bundler.
1. Fork this repository.
1. Install gems with `bundle install`.
1. Modify `spec/endpoints.rb` if you need.
1. Start building your app in `my_app` directory.
1. When you're done, create `my_app/start.sh` script (see *How do we verify your app* section below).
1. Send us link to your repository.
1. Wait for the new requirements.
1. Apply changes in `diff` branch.
1. Push `diff` branch.

### Testing your app
1. Modify `spec/endpoints.rb` if you need. **This is the only file you can modify in this repository**. It contains API hostname and its endpoints. You might want to use different ones.
3. Clear your app database, tests need database with no data.
3. Launch your app.
3. Run tests: 
```
bundle exec rspec --format=doc --color
```
Tests will hit your API according to the configuration in `spec/endpoints.rb` file.
 
## How do we verify your app after Codebase Part?

1. We clone your repo: `git clone {link-you-sent-us}`.
1. We go to the repo directory: `cd {repo-name}`.
1. We execute `./my_app/start.sh` and wait for server to start.
1. We execute `bundle exec rspec --format=doc --color`. There can be no test failures.

## How do we assess diffs?

Well... We don't know yet. We hope that after the first iteration we will be able to create some basic measurement tools.
This first time we will just take our best minds and try to choose best diffs together.

## Suggested order of making tests pass

1. `spec/requests/user_registration_spec.rb`
1. `spec/requests/groups_management_spec.rb`
    1. create
    1. index 

1. `spec/requests/orders_management_spec.rb`
    1. create
    1. index 
        1. Orders with Group
        1. Orders with Users
