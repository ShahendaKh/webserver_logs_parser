# Webserver Logs Parser

Script to parse web server log file for visited urls and the visitor's app and show insights for this data.

## Installation

Check out code, navigate to project's directory then execute:

    $ bundle install


## Usage

To run the script, you need to execute:

    $ ruby logs_parser.rb webserver.log

To run rubocop linter, you need to execute:

    $ bundle exec rubocop  

To run tests, you need to execute:

    $ bundle exec rspec

I also added rake tasks for simplicity. So you could also run:

    $ rake rubocop
    $ rake spec

## Test coverage
The code is 100% under test coverage.

## Architecture
There are two main objects that we'll be storing the data in them:
1- **UrlVisit**: Contains the url, visits count and the list of visitors as IPs
2- **VisitsStorage**: A map of values where the `url` is the key and the `UrlVisit` is the value.

The project's entry point is `logs_parser.rb` script. It first validates the existence of the file argument, then, it calls the *LogsParserService* class with the file name sent as the argument to start parsing the file. 

The *LogsParserService* starts by loading the file using the *FileLoaderService* which checks if the file exists either in the `data` folder or using the file name as an absolute path. If the file exists, the *FileLoaderService* will then return the file to be read line by line. After receiving the log file's lines, the *LogsParserService* creates a new *VisitsStorage* to start loading the parsed data in it.

After parsing and validating each line, the *LogsInsightsService* is called to show the collected insights to the user.

## To Do
Since this project's use case would be showing daily insights for a website or an api provider, I believe switching to saving to a **database** with timestamps would be essential. This could be easily visualized as a chart and would be very beneficial to the user viewing this data.

That being said, there are other improvements to be done:
1- More validations for the loaded file and its data.
2- Experiment with `benchmark-ips` gem to reach the best performance
3- Add an argument to the script to specify the sorting criteria
4- Improve showing insights logic and view
5- Move the script to a rake task as I believe this is more organized