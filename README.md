### Overview
This is a **Diff Challenge** repository. If you don't know what **Diff Challenge** is 
(and you don't, because this is the first one in existence!), 
read [this](https://github.com/elpassion/diff-challenge-1/wiki/Diff-Challenge) first.

#### First part (Codebase Part)
From the technical point of view, your task is to build an API which will pass the tests from this repository. From the business point of view, your task is to build an app for group food ordering.

API has to be written in Ruby, but besides that there are no other technical requirements. You can use whatever framework you want (or write your own).

There are 7 endpoints to implement which can be grouped in three categories:
- User registration and authentication (very basic).
- Creating Groups, i.e. collection of Users which can order food from a restaurant together.
- Creating Orders. Order can be assigned to an existing Group or to a collection of individuals created ad hoc by entering their emails.

You have to submit your solution to 3.04.2017, 3pm.

#### Second part (Diff Part)
After the Codebase Part all participants who submitted their solution will receive a new specification in form of updated tests. 
Diff created to meet these new requirements will be evaluated.
It will show us how easy your code can adapt to new business needs. 
For example, a few small changes in a few files are probably better than huge changes in many files.  

**Notes** 

- This is not about creating fully functional app. You'll implement very limited and simple features, 
so don't be surprise by the fact that there are no tests for validations, that authentication is very basic or that there is no endpoint for choosing meals.
- This is the first iteration of Diff Challenge **ever**. Please be patient, share your feedback, and most of all don't treat final results very seriously - we are not even sure how to measure diffs yet! 

### Steps

1. Install requirements:
    - Ruby 2.4.
    - Bundler.
1. Fork this repository.
1. Install gems with `bundle install`.
1. Modify `spec/endpoints.rb` if you need. Remember to commit your changes!
1. Start building your app in `my_app` directory.
1. When you're done, create `my_app/start.sh` script (see *How do we verify your app* section below). Remember to commit your changes, again!
1. Send us link to your repository. Use ssh (it starts with "git", for example `git@github.com:kv109/diff-challenge-1.git`).
1. Wait for the new requirements.
1. Apply changes in `diff` branch.
1. Push `diff` branch.

### Testing your app
1. Modify `spec/endpoints.rb` if you need. **This is the only file you can modify outside `my_app` directory**. It contains API hostname and its endpoints. You might want to use different ones.
3. Clear your app database, tests need database with no data.
3. Launch your app (i.e. start your server).
3. Run tests: 
```
bundle exec rspec --format=doc --color
```
Tests will hit your API according to the configuration in `spec/endpoints.rb` file.
 
### How do we verify your app after Codebase Part?

1. We clone your repo: `git clone {link-you-sent-us}`.
1. We go to the repo directory: `cd {repo-name}`.
1. We execute `cd my_app && ./start.sh` and wait for server to start.
1. We execute `bundle exec rspec --format=doc --color`. There can be no test failures.

### How do we assess diffs after Diff Part?

Well... We don't know yet. We hope that diffs from this first iteration will help us to create some basic measurement tools.
But for now we will just try to choose the best diffs collectively based on our knowledge and experience. 

After the assessment we plan to meet with all participants and talk about the best diffs. We'll try to explain our choice and, using chosen diffs as examples, 
dig into practices and techniques which made codebase easily adaptable in form of open discussion. **We consider this last part to be the most valuable**.

### Suggested order of making tests pass

1. `spec/requests/user_registration_spec.rb`
1. `spec/requests/groups_management_spec.rb`
    1. create
    1. index 

1. `spec/requests/orders_management_spec.rb`
    1. create
    1. index 
        1. Orders with Group
        1. Orders with Users
