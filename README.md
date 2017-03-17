# Binda
A lightweight CMS for Ruby on Rails 5, inspired by Spina.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'binda', github: 'a-barbieri/binda'
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