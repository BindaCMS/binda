# Binda
A lightweight CMS for Ruby on Rails 5, inspired by [Spina](http://www.spinacms.com).

[![Code Climate](https://codeclimate.com/github/a-barbieri/binda/badges/gpa.svg)](https://codeclimate.com/github/a-barbieri/binda)
[![Issue Count](https://codeclimate.com/github/a-barbieri/binda/badges/issue_count.svg)](https://codeclimate.com/github/a-barbieri/binda)
[![Test Coverage](https://codeclimate.com/github/a-barbieri/binda/badges/coverage.svg)](https://codeclimate.com/github/a-barbieri/binda/coverage)

<script async defer src="https://slack.yourdomain.com/slackin.js"></script>

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'binda', github: 'lacolonia/binda'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install binda
$ rails generate binda:install
```

## Requirements
Binda has some dependencies which you might need to update if you have a very specific environment.

If you are not going to use Rails default ORM please check [Carrierwave documentation](https://github.com/carrierwaveuploader/carrierwave#datamapper-mongoid-sequel) and [Devise documentation](https://github.com/plataformatec/devise#other-orms).

In order to use Carrierwave to process images you need to run MiniMagik. Please refer to [Carrierwave documentation](https://github.com/carrierwaveuploader/carrierwave#using-minimagick) to find more information.

## Bug reporting
Please refer to this [guide](http://yourbugreportneedsmore.info).

## Contributing
In order to contribute you need to have NodeJs and NPM installed.

If you are using NVM you can run the folloing command from the application root to detect the version specified on the repository.

```bash
$ nvm use .
```

If you are planning to work on the javascript files you need to open a terminal window and execute the following command. You need to keep that window open otherwise you will have to run the command every time you save a javascript file.

```bash
$ npm install
$ webpack
```

The main entry point is the `index.js`. To know more about how Webpack works please head to the [official documentation](https://webpack.js.org/).

Please comment your code as much as possible.

## License
The gem is available as open source under the terms of the [GNU General Public License v3.0](https://github.com/a-barbieri/binda/blob/master/LICENSE).

## Who is Binda?
Is [this guy here](https://en.wikipedia.org/wiki/Alfredo_Binda).

![Alfredo Binda 1927](./Alfredo_Binda_1927.jpg)
