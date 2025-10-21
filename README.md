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
   rails db:migrate
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

Run the RSpec test suite:

```bash
bundle exec rspec
```

Expected result:

* Model validation and association tests pass
* Some scaffold-generated request/view tests may remain pending (default behavior)

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

### What Still Needs Work
1. Write Cucumber feature files for user stories
2. Implement step definitions for Cucumber tests
3. Complete request/controller test implementations
4. Fix minor view test failure
5. Deploy to Heroku
6. Add any additional materials for submission


