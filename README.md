# Qualtrics

Interacts with the qualtrics web service including: token generation for SSO logins, API calls, and question mapping.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qualtrics'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qualtrics

## Usage

In order for everything to work a few environment variables are needed to be set:

* QUALTRICS_SURVEY_ID
* QUALTRICS_API_TOKEN
* QUALTRICS_USER_NAME
* QUALTRICS_SSO_SECRET_KEY
* QUALTRICS_LIBRARY_ID
* QUALTRICS_PANEL_ID


### Token generation

The default token generation is set to use MD5 and rijndael_128 ECB. This should be the default when using Qualtrics
[token based authenticator](http://www.qualtrics.com/university/researchsuite/advanced-building/survey-flow/authenticator/).

To use, initialize the Qualtrics token service object, and pass in an object that contains the following attributes:

* name_n: name.n string
* timestamp: now (see example below)
* expiration: now + 1 hour (see example)
* firstname: first name string
* lastname: last name string
* email: email string
* emplid: employee id string

Time format example:

```ruby
  def set_time
    now = Time.now.utc
    hour_from_now = now + 3600
    format = '%Y-%m-%dT%H:%M:%S'
    @timestamp = now.strftime(format)
    @expiration = hour_from_now.strftime(format)
  end
```

Example on how to use token generation:

First make sure you have an object with attributes mentioned above. Note that this could be an OpenStruct for something
lighter weight:

```ruby
require 'ostruct'
shib = OpenStruct.new
shib.name_n  = 'buckeye.1'
shib.first_name = 'Brutus'
shib.last_name = 'Buckeye'
shib.emplid = '111111111'
shib.timestamp = '2014-09-11T15:33:48'
shib.expiration = '2014-09-11T15:33:48'
```

Now instantiate the token service:

```ruby
qts = Qualtrics::TokenService.new(shib)
qts.get_url(survey_id: ENV['QUALTRICS_SURVEY_ID'])
```

for testing you can call the `get_test_url` method to make sure everything is wired up correctly:

```ruby
qts.get_test_url
```
