# training_tracker

A training tracker web app (WIP)

[![Code Climate](https://codeclimate.com/github/rtopitt/training_tracker/badges/gpa.svg)](https://codeclimate.com/github/rtopitt/training_tracker)
[![Test Coverage](https://codeclimate.com/github/rtopitt/training_tracker/badges/coverage.svg)](https://codeclimate.com/github/rtopitt/training_tracker/coverage)
[![Build Status](https://travis-ci.org/rtopitt/training_tracker.png?branch=master)](https://travis-ci.org/rtopitt/training_tracker)

**EXTREMELY ALPHA SOFTWARE!**, work in progress.

## Running on development

You will need:

- Ruby 2.3+
- PostgreSQL 9.4+

Clone the repo and create a `.env` file with values for your environment (use `.env.example` as a starting point, changing the values where needed).

Next run the standard Rails app setup:

```
$ bundle install
$ bundle exec rake db:setup
```

To start the app, run:

```
$ bin/foreman start
```

## Testing

Simply run:

```
$ bin/rake spec
```

## Contributing

Fork this repo, make your changes on your fork in a topic branch and submit a pull request against this repo's master branch.

Please write all code, comments, tests and commit messages in english. Use 2 spaces to indent code and follow idiomatic Ruby as close as possible. No CoffeeScript, please.

## License

This project is open source and licensed under the terms of the MIT License. See `LICENSE` for more information.
