# Binda
A modular CMS for Ruby on Rails 5.

[![Code Climate](https://codeclimate.com/github/lacolonia/binda/badges/gpa.svg)](https://codeclimate.com/github/lacolonia/binda)
[![Issue Count](https://codeclimate.com/github/lacolonia/binda/badges/issue_count.svg)](https://codeclimate.com/github/lacolonia/binda)
[![Test Coverage](https://codeclimate.com/github/lacolonia/binda/badges/coverage.svg)](https://codeclimate.com/github/lacolonia/binda/coverage)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'binda', '~> 0.0.3'
```

Then execute:
```bash
$ bundle
```

To install Binda run the installer from terminal. 
``` bash
$ rails g binda:install
```

Now you are good to go. Run `rails s` and check the administration panel at `http://localhost:3000/admin_panel`.

To get into details read [Binda Guidelines](https://github.com/lacolonia/binda/wiki).

**Warning: run the installer once.** Running the installer for each application environment will cause issues with users' passwords. Also remember that if you need to re-install Binda you need to drop all Binda database tables first. More details [here](https://github.com/lacolonia/binda/wiki/Installation)

## Bug reporting
Please refer to this [guide](http://yourbugreportneedsmore.info).
If you need direct help you can join [Binda Slack Community](https://bindacms.slack.com).


## License
The gem is available as open source under the terms of the [GNU General Public License v3.0](https://github.com/a-barbieri/binda/blob/master/LICENSE).

## Credits
Binda is inspired by [Spina CMS](https://github.com/denkGroot/Spina).

We give also credit to authors and contributors of the gems that Binda uses. Huge thank you to all of them.

## Who is Binda?
Is [this guy here](https://en.wikipedia.org/wiki/Alfredo_Binda).

![Alfredo Binda 1927](./Alfredo_Binda_1927.jpg)
