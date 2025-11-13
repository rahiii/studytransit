# Study Transit


## Team Members
- Zaryaab Khan (zfk2107)
- Rahi Mitra (rm381)
- Noel Negron (nmn2127)
- Erick Berlanga (eb3515)


## Overview
Study Transit is a Rails web application that helps students find available study spaces at libraries. The application allows users to view libraries and their study spaces, see real-time capacity information, and contribute to crowdsourced ratings of how full each space is.


**Iteration 2** focuses on implementing crowdsourced rating reporting and capacity management with real-time updates (via page refresh).


### Core Functionality


**Libraries and Spaces**
- Each Library (e.g., Butler Library) has multiple Spaces (e.g., Main Room, Room 209)
- Libraries have a name and location
- Spaces have a name and belong to a library


**Capacity Management**
- Users can set and update a space's capacity (1-5 scale)
- When a capacity is set or updated, it automatically creates a rating entry
- Capacity updates are validated to ensure values are between 1 and 5


**Crowdsourced Rating System**
- Users can rate how full a space is (1-5 scale) via the ratings API
- The system tracks ratings with session identifiers to prevent duplicate ratings within the same hour
- Ratings are aggregated to show average occupancy levels of a space


**Real-Time Capacity Display**
- The application displays average ratings from the past hour
- If no recent ratings exist, it falls back to showing the average from the same time last week
- Capacity is visualized using person icons (👤) - the number of icons corresponds to the average rating (rounded)
- **Note:** "Real-time" updates require users to refresh the page to see the latest capacity information. The capacity system works correctly when the page is refreshed after updates, or when the user goes back to see the views. 


**Rating Features**
- Average rating calculation from the past hour are based on inputted user data
- When the average is unknown, our system falls back to using data stored from last week's.
- Timestamp display showing when ratings were last updated
- Visual indicators showing whether data is from recent ratings or historical fallback


**Focus Sessions (Lock In Feature)**
- Study timer with configurable duration (15-180 minutes in 15-minute increments)
- Visual progress ring showing timer countdown
- Survey model to rate the current study space (1-5 scale)
- Search functionality to find and select study spaces
- Integration with ratings API to submit space occupancy ratings
- Session management with start, cancel, and reset functionality
- Accessible via footer navigation icon


**Potential Next Integrations for our Demo**
- Adding an authentication feature. By allowing users to authenticate, we plan to expand the Lock-In feature to include “Streaks.”
- The Streak incentive will further reinforce our crowdsourcing, as the Streaks will have users utilizing our app more frequently. 






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


5. Navigate the application:
  - **Home**: View all libraries and their study spaces
  - **Lock In**: Access focus timer and space rating survey (via footer icon)


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


## Progress Status (Iteration 2)


### What's Done


**RSpec Tests**
- Model tests implemented and passing:
 - Library model: validation tests for name/location presence, has_many association
 - Space model: validation tests for name presence, capacity range (1-5), belongs_to association, rating methods
 - Rating model: validation tests for value range and presence, belongs_to association
- Request tests for controllers
- View tests for library and space views
- Test suite runs successfully


**Working SaaS Prototype**
- Rails application with Library, Space, and Rating models
- Database migrations created and working
- CRUD operations for libraries and spaces
- JSON API for ratings creation
- Model validations working correctly
- MVC structure with proper separation of concerns
- Real-time capacity updates (via page refresh)


**User Stories (Cucumber)**
- Feature files and step definitions implemented for:
 - Viewing libraries and their spaces
 - Viewing space capacity indicators with person icons
 - Updating a space's capacity with validation
 - Viewing crowdsourced ratings and averages
 - Seeing rating timestamps and historical data indicators


**Key Features Implemented**
- Crowdsourced rating system with session tracking
- Average rating calculation with historical fallback
- Capacity management with automatic rating creation
- Visual capacity indicators (person icons)
- Real-time capacity display (updates on page refresh)
- Rating timestamps and data freshness indicators
- Focus Sessions (Lock In) feature with study timer
- Interactive survey modal for space rating
- Search functionality for finding study spaces
- Responsive UI with footer navigation


## Links for Submission


- Heroku deployment: [(Heroku)](https://tranquil-springs-29537-42430299ccf0.herokuapp.com/)
- GitHub repository: [(Github)](https://github.com/rahiii/studytransit/)


## Submission Checklist (Iteration 2)


- Names and UNIs listed above
- Run instructions included; test instructions for RSpec and Cucumber included
- Cucumber user stories for main features present and runnable
- RSpec tests present and runnable with good coverage
- Prototype runs locally and passes tests
- Heroku deployment link provided
- GitHub repository link provided
- Crowdsourced rating system implemented
- Real-time capacity updates working
- Average rating calculation with historical fallback
- Capacity management with validation
- Focus Sessions (Lock In) feature with study timer
- Interactive space rating survey









