## Reward Points Management API Application

## Requirements

**Ensure you have the following installed:**

* Ruby 3.1.4
* Rails 7.0.8
* PostgreSQL (version 13 or later)

### Setting Up Development Environment

1. **Clone the repository.**
2. **Install gems:**  `bundle install`
3. **Set up the database:**
   ### This is pretty standard to Ruby On Rails app, but always nice to remember: just set up the config/database.yml file with your local database credentials. Sample already exists at config/database.yml.example for reference
   * Create the database: `bundle exec rails db:create`
   * Migrate the databse: `bundle exec rails db:migrate`
4. **Start the Rails server:** `bundle exec rails s`

### Running Tests

* Run unit and integration tests: `rails test`
* Run a single test: `rails test test_file_path.rb`

### Postman Collection

Documentation of API's collection for testing is available in Postman.
Access it here: https://documenter.getpostman.com/view/27322135/2sA3drHEBH

### Features

- User Authentication: Basic Authentication is used for API users with has_secure_password for secure password storage and authentication.

- Unit and Integration Tests: Includes comprehensive tests under /test using MiniTest to ensure functionality.

- API Focus: This application is created only for API endpoints to maintain a lightweight and focused architecture.

- GitHub Action: Added a script to run test cases on every push and when creating a pull request on GitHub.
                 Check Logs on GitHub: https://github.com/shrreeyy/points_management/actions