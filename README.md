# Study Transit

## Team Members
- Zaryaab Khan (zfk2107)
- Rahi Mitra (rm381)
- Noel Negron (nmn2127)
- Erick Berlanga (eb3515)

## Overview
Study Transit is a basic Rails web application for managing libraries and their study spaces.  
Each Library (e.g., Butler Library) has multiple Spaces (e.g., Main Room, Room 209).  
Each Space includes a crowd rating from 1 to 5, representing how full it is.

This version includes working models, validations, views, and RSpec tests.

## Instructions to Run

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set up the database:

   ```bash
   bundle exec rails db:migrate
   bundle exec rails db:seed
   ```

3. Start the Rails server:

   ```bash
   rails server
   ```

4. Open the app in a browser:

   ```
   http://localhost:3000/libraries
   ```

## Instructions to Test

Run the RSpec unit/request/view tests:

```bash
bundle exec rspec
```

Run the Cucumber user stories (acceptance tests):

```bash
bundle exec cucumber
```

Expected result:

- Model validation and association tests pass
- Cucumber features for viewing libraries/spaces and updating capacity pass

## Progress Status

### What's Done

**RSpec Tests**
- Model tests are implemented and passing:
  - Library model: validation tests for name/location presence, has_many association
  - Space model: validation tests for name presence, occupancy range (1-5), belongs_to association
- Test suite runs successfully (61 examples, 1 minor failure, 26 pending scaffold tests)

**Working SaaS Prototype**
- Rails application with Library and Space models
- Database migrations created and working
- CRUD operations for both models implemented
- Model validations working correctly
- Basic MVC structure in place

**User Stories (Cucumber)**
- Feature files and step definitions are present for:
  - Viewing libraries and their spaces
  - Viewing space capacity indicators
  - Updating a space's capacity with validation

### What Still Needs Work
1. Complete request/controller test implementations as needed
2. Fix any remaining view spec failures if present
3. Deploy to Heroku and add the live URL below
4. Add any additional materials for submission (screenshots, notes)

## Links for Submission

- Heroku deployment: [(https://tranquil-springs-29537-42430299ccf0.herokuapp.com/)](https://tranquil-springs-29537-42430299ccf0.herokuapp.com/)
- GitHub repository: [<ADD_GITHUB_REPOSITORY_URL_HERE>](https://github.com/rahiii/studytransit/)

## Submission Checklist (Iteration 1)

- Names and UNIs listed above
- Run instructions included; test instructions for RSpec and Cucumber included
- Cucumber user stories for core features present and runnable
- RSpec tests present and runnable
- Prototype runs locally and passes tests
- Heroku deployment link provided
- GitHub repository link provided
- Optional additional materials included


