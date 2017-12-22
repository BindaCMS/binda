# Binda
A modular CMS for Ruby on Rails 5.1.

[![Code Climate](https://codeclimate.com/github/lacolonia/binda/badges/gpa.svg)](https://codeclimate.com/github/lacolonia/binda)
[![Issue Count](https://codeclimate.com/github/lacolonia/binda/badges/issue_count.svg)](https://codeclimate.com/github/lacolonia/binda)
[![Build Status](https://travis-ci.org/a-barbieri/binda.svg?branch=master)](https://travis-ci.org/lacolonia/binda)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5dc62774a6b8b63aa72b/test_coverage)](https://codeclimate.com/github/lacolonia/binda/test_coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/lacolonia/binda.svg)](https://gemnasium.com/github.com/lacolonia/binda)
[![Inline docs](http://inch-ci.org/github/lacolonia/binda.svg?branch=master)](http://inch-ci.org/github/lacolonia/binda)

> This documentation has been written for the [Official Documentation](http://www.rubydoc.info/gems/binda), not the Github README. 
> If you still prefer to read Github README be aware that links might not work properly.

---



# Quick Start

**Binda** is a CMS with an intuitive out-of-the-box interface to manage and customize page components.

The core element is the _structure_ element which is the finger print of any _component_ instance. Every _structure_ can have one or more _field-groups_ which can be populated with several _field-settings_. _Field-groups_ and _field-settings_ represent _components_ features, such as galleries, textareas, dates, repeaters and so on.

Let's say your website needs a set of pages with a subtitle. That's super easy. 

- create a "Page" _structure_
- go to General Details of "Page" _structure_ (see the small pencil icon)
- set a "Subtitle" _field-settings_ based both on a _String_ field type. 

Done! Now you'll see the "Pages" tab in your menu which will contain all your pages.

It's easier learning by doing than by reading. ;-)

![Binda preview](https://www.dropbox.com/s/m7vwrou1homqc6p/binda-01.gif?raw=1)

---



# Installation

Install Binda via terminal

```bash
gem install binda
```

alternatively add the gem to your application's Gemfile:

```ruby
gem 'binda'
```

Then execute:

```bash
bundle install
```

Before completing the installation you need to setup the database. If you are going to use Postgres set it up now.

To complete binda installation run the installer from terminal. Binda will take you through a bit of configuration where you will setup the first user and some basic details.

```bash
rails generate binda:install
```

Now you are good to go. Good job!

## Recommended workflow

Binda is totally bound to its database in order to let you structure your CMS directly from the admin panel. The recommended workflow is:

1. Install and develop the application locally
2. Migrate server and database to production once ready
3. For any update sync your local database with the production one

This ensure the application structure remains the same.

If you want to avoid copying the entire database you can just refer to the following `binda_structures`

## Reset credentials and initial settings

If you need to re-install Binda and reset initial database settings (such as username and password for example) execute the following command from the application root.

```bash
rails generate binda:setup
```

## Specific needs
In order to use Carrierwave to process images you need to run MiniMagik. Please refer to [Carrierwave documentation](https://github.com/carrierwaveuploader/carrierwave#using-minimagick) to find more information.

If you are not going to use Rails default ORM please check [Carrierwave documentation](https://github.com/carrierwaveuploader/carrierwave#datamapper-mongoid-sequel) and [Devise documentation](https://github.com/plataformatec/devise#other-orms).

---



# Settings

Binda comes with some default preferences.

During the installation process you will be asked to provide the _website name_, _website description_ and the credentials for the default super administrator.

This two preferences can be changed later on inside _Dashboard_ panel visible in the sidebar. 

You can customize the _Dashboard_ panel adding, removing and modifing fields as you prefer. As a matter of fact in _Structures_ you can find the one related to _Dashboard_ which you can edit as you like. The only thing you shouldn't do is to turn it into a component!

You can also create new boards if you need it. See https://github.com/lacolonia/binda/wiki/Boards

By default after the installation a `Board` called `dashboard` will be populated with three fields: a `Radio` called `maintenance-mode`, a `String` called `website-name` and `Text` called `webiste-description`.

You can retrieve them this way:

```ruby
B.get_boards('dashboard').first.get_radio_choice('maintenance-mode')
# => return string which can be 'true' or 'false'
B.get_boards('dashboard').first.get_string('website-name')
# => return string with website name
B.get_boards('dashboard').first.get_text('website-description')
# => return text with website description
```

---



# Structures

_Structures_ are the DNA of the application _components_ and _boards_. Each _component_ and _board_ is defined by a _structure_. 

## Create a structure

Creating a _structure_ is fairly easy. Just click on the sidebar tab called _Structures_ and then on the _New structure_ button. You will be asked to provide a name which will be used from then on to call the relative component or board. You can also select the type of structure: _component_ or _board_. The former will let you create multiple instances for that structure whereas the latter will let you create only one instance. Why? A _component_ is great for something like posts, pages and so on. _Board_ are useful for content that is set once throghout the application, for example the website description.

Once the _structure_ has been created it's possible to add field groups. By default there is one field group called *General Details* which is empty. You can customize that or add new ones.

In order to add _field settings_ that will let you add content to your _component_ (or _board_) you need to enter on of the _structure's field groups_.

## Retrieve a structure

Once you create a _structure_ you can call it from your controller like so:

```ruby
@my_structure = Binda::Structure.find_by(slug: 'my-structure')
```

From that you can do all sorts of things.

```ruby
# get all field groups
@field_groups = @my_structure.field_groups

# get all field settings
@field_settings = []
@field_groups.each do |group|
  group.field_settings.each do |setting|
    @field_settings << setting
  end
end
```

Depending on the structure type, to retrieve all related _components_ or the related _board_ you can use the Binda helper (which is suggested if you care about performance, see [component](#Components) or [board](#Boards)) or do it the usual Ruby on Rails way like so:

```ruby
# if structure is a component type
@components = @my_structure.components

# if structure is a board type
@board = @my_structure.board
```

---



# Components

_Components_ are instances of a _structure_.

In order to retrieve a single _component_ you can use one of the following methods:

## Using the helper

A useful helper is `B.get_components`. This helper will retrieve all _components_ from a specific _structure_. Find specific info in the [technical documentation](http://www.rubydoc.info/gems/binda/Binda/DefaultHelpers).

Then in any of your controllers you can retrive the components belonging to a specific structure just using the structure slug. Let's see an example that uses the `page` structure to retrieve all related components.

```ruby
B.get_components('page')
# return all pages

B.get_components('page')
     .find_by(slug: 'my-first-page')
# return `my-first-page`

# expand query
B.get_components('page')
     .published
     .order('position')

# reduce N+1 query issue by including dependencies
B.get_components('page')
     .includes(:strings, :texts, repeaters: [:images, :selections])
```

To be able to use this helper in the application console you need to run `Binda.include Bidna::DefaultHelpers`

## Using the rails way

Retrieve a single component

```ruby
@component = Binda::Component.find_by( slug: 'my-first-component')
```

Retrieve a single component but eager load the field setting needed. This optimize the query and greatly reduce request time.

```ruby
@component = Binda::Component.where(slug: 'my-first-component')
                             .includes( :strings, :texts, :assets, :selections )
                             .first
```

Then, if you want to retrieve all components that belongs to a specific structure **don't** do the following:

```ruby
# SLOW
@structure = Binda::Structure.find_by( slug: 'my-structure')
@components = @structure.components
```

**Do this instead!**

```ruby
# FASTER
@components = Binda::Component.where( structure_id: Binda::Structure.where( slug: 'my-structure' ) )

# which is the same thing of doing:
@components = B.get_components('my-structure')
```

You can add any other option to the query then:

```ruby
@components = Binda::Component.where( structure_id: Binda::Structure.where( slug: 'my-structure' ) )
                              .published
                              .order('name')
                              .includes( :strings, :texts, :assets, :selections )

# which is the same thing of doing:
@components = B.get_components('my-structure')
                   .published
                   .order('name')
                   .includes( :strings, :texts, :assets, :selections )
```

## Enable preview

When you created the component structure you might have enabled the **preview mode**. The easiest way to integrate the preview with yor application is to update the `config/routes.rb` file with a redirect that binds the component preview url to the controller that is in chardge of showing that component in your application.

For example let's say you have a *animal* structure with slug `animal`: 

```ruby 
# your application single animal route
get 'animals/:slug', to: 'animals#show', as: animal

# the bound to a animal preview should be
get "admin_panel/animal/:slug", to: redirect('/animals/%{slug}')
```

---



# Boards

_Boards_ give you the possibility to have a panel where to list some specific settings. 

A great example of a _board_ is the _Dashboard_. This board is useful to store the generic data which can be used throughout the application, like the website name and description.

You can create as many _boards_ you like and add any field you want. To set up a _board_ go to _Structures_ and create a new _structure_ with type "_board_". The name of the structure will determine also the name of the board. Once created a new tab will appear on the main sidebar. The newly created structure is already populated with the _General Details_ field group which is initially empty. To add new field settings you can decide to edit this field group or create a new field group.

Once ready you can head to the _board_ page by clicking the tab on the main sidebar and populate the fields with your content.

To retrieve _board_ content you can use one of those methods:

```ruby
@board = Binda::Board.find_by(slug: 'my_board')

@board = B.get_boards('my-board').first
```

## Board Helpers

If you care about performance you can use the `Binda.get_board` helper to retrieve the _board_ object.

This method retrieves a **board**. Find specific info in the [technical documentation](http://www.rubydoc.info/gems/binda/Binda/DefaultHelpers).

```ruby
B.get_boards('my-dashboard').first
# return the board

# reduce N+1 query issue by including dependencies
B.get_boards('default-dashboard')
     .includes(:strings, :texts, repeaters: [:images, :selections])
     .first
```

_Boards_ can make use of all field helpers. See the [fields documentation](#Field_Helpers) for more information.

To be able to use this helper in the application console you need to run `Binda.include Bidna::DefaultHelpers`

## Using console

If you are going to use Rails console you need to know that a _board_ is automatically generated once you create a _structure_ with an `instance_type` of `board`.

Example:

```bash
board_structure = Binda::Structure.create!(name: 'new dashboard', instance_type: 'board')
board = board_structure.board
```

---



# Fields

Every _field setting_ is based on a field type. You can create several field settings based on a single field type. 

Here below a list of field types available and their use:

| Field setting | Use details |
|---|---|
| String | Store a string. No formatting options available. |
| Text | Store a text. TinyMCE let's you format the text as you like.   |
| Image | Store image. |
| Video | Store video. |
| Date | Store a date. |
| Radio | Select one choice amongst a custom set. |
| Selection | Select one or more choices amongst a custom set. |
| Check Box | Select one or more choices amongst a custom set. |
| Repeater | Store multiple instances of a field or a collection of fields. |
| Relation | Connect multiple instances of a _component_ or _board_ to each other. |

## How to get field content

Every field setting has a unique `slug`. The default `slug` is made of the `structure name + field group name + field setting name`. If it's a child of a _repeater_ the slug will include the _repeater_ slug as well. You can customise the `slug` as you like keeping in mind that there every `slug` can be attach to only one field setting. 

In order to retrieve a field content you can use one of the following helpers.

Let's say you want to get a specific field from a _component_ instance:

```ruby
# controller file
@article = B.get_components('article').first

# view file
@article.get_text('description')
# => 'Hello world'
```

This helpers will work for any instance of `Binda::Component`, `Binda::Board` and `Binda::Repeater`.

## Field Helpers

Here below a list of helpers. 

You can retrieve field content from a instance of `Binda::Component`, `Binda::Board` or `Binda::Repeater`. See [How to get field content](#How_to_get_field_content).

**NOTE: source links are based on the latest public version.** If you are using an older version or a specific branch please refer to the [source](https://github.com/lacolonia/binda/blob/master/app/models/concerns/binda/fieldable_associations.rb) switching to the branch/tag you are looking for.

| Helper |||
|---|---|---|
| `has_text`| Returns `true/false` | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_text) |
| `get_text`| Returns the text. Use [`simple_format`](https://apidock.com/rails/ActionView/Helpers/TextHelper/simple_format) to maintain HTML tags. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_text) |
| `has_string`| Returns `true/false`. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_string) |
| `get_string`| Returns the text. Use [`simple_format`](https://apidock.com/rails/ActionView/Helpers/TextHelper/simple_format) to maintain HTML tags. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_string) |
|`has_image`| Returns `true/false`.| [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_image) |
|`get_image_url(size)`| Returns the url of the image. A thumbnail version (200x200) by specifying `thumb` size. If no size is provided the method will return the original image size. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_image_url) |
|`get_image_path(size)`| Returns the path of the image. A thumbnail version (200x200) by specifying `thumb` size. If no size is provided the method will return the original image size. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_image_path) |
|`has_video`| Returns `true/false`.| [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_video) |
|`get_video_url`| Returns the url of the video. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_video_url) |
|`get_video_path`| Returns the path of the video. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_image_path) |
|`has_date`| Returns `true/false` | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_date) |
|`get_date`| Returns the date in `datetime` format. Use [`strftime`](https://apidock.com/rails/ActiveSupport/TimeWithZone/strftime) to change date format. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_date) |
|`has_repeater`| Returns `true/false`| [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_repeater) |
|`get_repeater`| Returns an array of repeaters. See next session for more details. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_repeater) |
|`get_selection_choice`| Returns an hash with label and value of the selected choice. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_selection_choice) |
|`get_radio_choice`| Returns an hash with label and value of the selected choice. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_radio_choice) |
|`get_checkbox_choices`| Returns an array of label/value pairs of all the selected choices. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:get_checkbox_choices) |
|`has_related_components`| Check if has related components. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_related_components) |
|`get_related_components`| Retrieve related components. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_related_components) |
|`has_related_boards`| Check if has related boards. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_related_boards) |
|`get_related_boards`| Retrieve related boards. | [source](http://www.rubydoc.info/gems/binda/Binda/FieldableAssociations:has_related_boards) |

If you need to get each dependent of all relations with a specified slug (or slugs) you can use `B.get_relation_dependents` helper. This is very useful to retrieve only the instances which have a owner (and therefore are 'dependents'). 

For example, you have several `event` components, each related to several `artist` components with a `partecipants` relation field where every event owns some artists. If you want to retrieve all artists which have been involved in at least one event you can try with 

```ruby
B.get_relation_dependents('partecipants')
# returns all artists which are related to at least one event
```

If you want to retrieve each owner of all relations with the specified slug (or slugs) you can do the following:

```ruby
B.get_relation_owners('partecipants')
# returns all events which are related to at least one artist
```


---



# Repeaters

Generally a _field setting_ is associated to a single content entry. Therefore if a _field setting_ has type `text` there will be only one `Binda::Text` related to it.

If you want to have multiple entries for a single _field setting_ you need to create a _repeater_. 

For example: lets say you have a _Movie_ component and you need to list some credits. You can create a _repeater_ and add a field setting with type `string` and name it _credit_. In the _movie_ editor you will able to add as many credit field you like. 

Another example: imagine you setup a repeater with two children, a string and a asset field.

```
page (structure)
|__ default details (field_group)
    |__ slide (repeater)
        |__ title (string)
        |__ image (asset)
```

Then on the component editor you can

```
My first page (component)
|__ slide_1
    |__ 'My first slide'
    |__ img_1.png
|__ slide_2
    |__ 'My second slide'
    |__ img_2.png
|__ slide_3
    |__ 'My last slide'
    |__ img_999.png

```

The code can be something like this:

```ruby
@page = B.get_components('page')
             .where(slug: 'my-first-page')
             .includes(repeaters: [:texts, :images])
             .first

@page.get_repeater('slide').each do |slide|
  slide.title
  slide.get_image_path
end
```

To be able to use this helper in the application console you need to run `Binda.include Bidna::DefaultHelpers`

The repeater model `Binda::Repeater` can make use of any of the [field helpers](#Field_Helpers).

---



# Users

Binda offers two main roles. The **super admin** which is capable of administrating the entire website and the **standard admin** user which cannot manage the structures, field groups and field settings.

In case you cannot access with your account anymore you can create a new **super admin** via console running this task:

```bash
rails binda:create_super_admin
```

---


# Maintenance Mode

Binda offers a maintenance mode out-of-the-box. In your routes you will find:

```ruby
# config/routes.rb
get 'maintenance', to: 'maintenance#index', as: 'maintenance'
```

You can change the url to be whatever you like, as long as you keep the route name. For example

```ruby
# config/routes.rb
get 'under_construction', to: 'maintenance#index', as: 'maintenance'
```

The maintenance behaviour is controlled by the `MaintenanceHelper` included in your `app/controllers/application_controller.rb`. If you don't have it make sure it's included this way: 

```ruby
# app/controllers/application_controller.rb
include ::Binda::MaintenanceHelpers
```

## Customize maintenance appeareance

The maintenance mode is controlled by the `app/controllers/maintenance_controller.rb` which renders a single view: `app/views/layouts/maintenance.html.erb`. You can do whatever you like with it.

To change appereance and behaviour of the page add your styles to `app/assets/stylesheets/maintenance.scss` and your scripts to `app/assets/javascript/maintenance.js`. These are manifest files so if you need jQuery for example, you just need to add `//= jquery` at the top of `maintenance.js` file.

---


# Plugins

Here a list of useful plugins:

- [Binda Multilanguage](https://github.com/lacolonia/binda_multilanguage)

---



# Upgrade

Here some upgrade instruction.


To upgrade from 0.0.6 to 0.0.7 please refer to the [release documentation](https://github.com/lacolonia/binda/releases/tag/0.0.7)

---



# Create a Binda plugin

You can create a plugin to add new features to Binda. This is the most suitable and correct way to develop a new feature that will be possibly shared and use by everyone in the future.

The first step is to create a plugin.
```
rails plugin new binda_new_feature --skip-test --dummy-path=spec/dummy --mountable
```
This will create a folder `binda_new_feature` which will contain your plugin `BindaNewFeature`. 

We will `--skip-test` as we are going to use Rspec instead of standard Ruby on Rails test suite. For the same reason the `--dummy-path` will change to `spec/dummy`. Ultimately we want the plugin to be `--mountable`.

## Add dependencies
Populate `binda_new_feature.gemspec` with dependencies and replace every `TODO` with a content that makes sense.

```ruby
# binda_new_feature.gemspec

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binda_new_feature/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binda_new_feature"
  s.version     = BindaNewFeature::VERSION
  s.authors     = ["Me"]
  s.email       = ["me@mydomain.com"]
  s.homepage    = "http://mydomain.com"
  s.summary     = "Binda New Feature is plugin for Binda CMS"
  s.description = "Use this plugin to enable new feature in your application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0", "< 5.2"
  s.add_dependency "binda", "~> 0.0"

  # Test suite
  s.add_development_dependency "rspec-rails", ">= 3.5", "< 3.7"
end
```

Make sure all dependencies are versioned in order to avoid issues due to deprecation in future releases. (The above versions are dated 07/2017)

## Prepare plugin for testing
Before coding anything make sure you complete the following steps: 


1) Install Rspec

```
rails generate rspec:install
```

2) Install Binda on the dummy application

```
cd spec/dummy
rails generate binda:install
```

3) Tell `config.generators` to use Rspec:

```ruby
# lib/binda_new_feature/engine.rb

module BindaNewFeature
  class Engine < ::Rails::Engine
    isolate_namespace BindaNewFeature

    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
```

This makes sure Rails uses Rspec to create test specs every time you generate something with `rails g` command (be it a model, controller or scaffold).

4) change a line in `spec/rails_helper.rb`

```ruby
# require File.expand_path('../../config/environment', __FILE__)
# should be changed to
require File.expand_path('../dummy/config/environment', __FILE__)
```

## Create a first test
Let's create a fake controller to see if the plugin works.

```
rails generate controller binda/foo index --skip-namespace
```

This command create a controller called `Binda::Foo` which will be integrated to `Binda` engine and, we have done everything correctly, we should have a spec ready to be populated with tests in `spec/controllers/binda/foo_controller_spec.rb`.

Lets add Binda routes to that spec. (See why you need to specify routes [here](https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests))

```ruby
# spec/controllers/binda/foo_controller_spec.rb

require 'rails_helper'

module BindaNewFeature
  RSpec.describe FooController, type: :controller do

    # This line is very important
    routes { Binda::Engine.routes }

    describe 'GET #index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

  end
end
```

The generator unfortunately creates a namespace inside `BindaNewFeature::Engine.routes` which we will not use. Instead add the folloing lines which uses `Binda::Engine.routes`

```ruby
# config/routes.rb

BindaNewFeature::Engine.routes.draw do
end

Binda::Engine.routes.draw do
  get 'foo', to: 'foo#index'
end
```

Now running `rspec` the test should pass. (you might have 2 pending examples for foo helper and view, but that's not a problem for now).

## Extend a Binda models and controllers
Sometimes you want to add new methods to Binda models with your plugin. In order to do it you need to make your plugin aware of Binda and its models. To achive it require Binda at the top of the `lib/binda_new_feature/engine.rb` like so:

```ruby
require "binda"
```

If you want to access Binda::ApplicationController to inherit its methods change the parent_controller configuration of your plugin in the same file:

```ruby
# lib/binda_new_feature/engine.rb

# ... all `require` gems

module BindaNewFeature
  class Engine < ::Rails::Engine

    # ... some other code

    config.parent_controller = 'Binda::ApplicationController'
  end
end
```

---



# How to create a form of nested components

Let's say you have a component which depends on another components and you want your user to edit both of them in the same form. No problem.

```ruby
# controller
# Let's say your structure has slug = `my_structure` and id = `123`
# and you want to edit `component_A` and its child `component_B` 

@structure = Binda::Structure.find(123)
# or if you use Friendly_id
@structure = Binda::Structure.friendly.find('my_structure')

@component_A = @structure.components.detect{|c| c.slug == 'component_A'}
@component_B = @structure.components.detect{|c| c.slug == 'component_B'}
```

```ruby
# view
<%= simple_form_for @structure, html: { class: 'some-form-class' } do |f| %>
  <%= f.simple_fields_for :components, @component_A do |A| %>
    <=% A.input :name_of_a_column %>
    <=% A.input :name_of_another_column %>
  <% end %>
  <%= f.simple_fields_for :components, @component_B do |B| %>
    <=% B.input :name_of_a_column %>
    <=% B.input :name_of_another_column %>
  <% end %>
<% end %>
```

---



# How to contribute

Any contribution is more than welcome.

To contribute [fork this project](https://github.com/lacolonia/binda/wiki/_new#fork-destination-box) and clone the fork in your local machine. There you are free to experiment following this principles:
- before diving into the code [open a issue](https://github.com/lacolonia/binda/issues/new) to explain what you'd like to do
- don't add gem dependencies unless it's absolutely necessary
- keep it simple and be DRY
- add [tests](#How_to_test)
- comment your code following [Yard guidelines](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md) principles (use `yard server -r` to see the HTML version at `http://localhost:8808`, if you make any change to the doc just refresh the page and the documentaion page gets updated automagically)
- update the README.rb file, use Github markdown
- if you are not adding a core feature consider writing a plugin instead
- improve and/or add new I18n translations
- when fixing a bug, provide a failing test case that your patch solves

## How to work locally
Ensure you have installed Binda dependencies.

```bash
cd path/to/binda
bundle install
npm install
```

To see what you are actually doing you can make use of the **dummy application** which is shipped with Binda.

Ensure you have Postgres up and running, then create dummy databases.

```bash
cd spec/dummy
rails db:create
```

If you haven't already, install Binda.

```bash
rails generate binda:install
```

In order to edit javascript files you need to run Webpack and leave the terminal window open, so Webpack can compile everytime you save a file. To install Webpack run `npm install` from the root of your application. Then everytime you want to edit a javascript file run:

```bash
webpack
```

If you need to reset your database run the following commands

```
cd spec/dummy
rails db:drop && rails db:create
rails generate binda:setup
```

In order to make the dummy application flexible any update to that folder isn't saved in the repository.

This let you as you prefer with your dummy without the hassle of cleaning it before creating a commit.

## How to test
In order to avoid the *it works on my machine* issue, test are run via Travis every time a commit is pushed. Make sure you register your forked version on Travis in order to test every commit. If you don't the forked version will be tested once you make a pull request to the original repository.

If you want (and you should) test locally Binda use RSpec, FactoryGirl and Capybara to run tests. You can find all specs in `spec` folder. Capybara needs Firefox and [Geckodriver](https://github.com/mozilla/geckodriver) to run so make sure you have it installed in your machine. If you have Node you can install Geckodriver via npm:

```bash
npm install --global geckodriver
```

Some specs are run against the database. If you haven't installed Binda on the dummy application yet run:

```bash
rails db:migrate RAILS_ENV=test
```

The above command might generate an error. This is probably because you have previously installed Binda and the generator finds migration both in `binda/db/migrate` and `binda/spec/dummy/db/migrate`. To solve the issue, remove the `spec/dummy/db/migrate` folder and run the previous command again. Here below the oneliner (be aware that this destroy both development and test databases of the dummy app):

```bash
rm -rf spec/dummy/db/migrate && rails db:drop && rails db:create && rails generate binda:install && rails db:migrate RAILS_ENV=test
```

In case you are creating new migrations or modifing the default one, consider running the above command to refresh the `schema.rb` file while updating both databases.

If in the future you need to clean your dummy app code, simply run:

```bash
rm -rf spec/dummy && git checkout spec/dummy
```

**The command above should be run before any commit!**

Once all setup is done run RSpec every time you update the specs:

```bash
rpsec
```

Some helpful hints to debug tests are:

1. Add `save_and_open_page` command in the code of the test example. This will save the page and let you inspect it.
2. Add `binding.pry` this will stop the test and let you inspect the code at that moment of the code.
3. In the command line, from Binda root folder, execute `tail -f ./spec/dummy/log/test.log` this will give you the list of operations executed by the server while you are running the test.

## Update test coverage

Once tests are done update Code-Climate test coverage locally (Mac OSX).

```bash
$ cd path/to/binda
$ curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-0.1.4-darwin-amd64 > ./cc-test-reporter
$ chmod +x ./cc-test-reporter
$ ./cc-test-reporter before-build
$ rspec
$ ./cc-test-reporter after-build -r a8789f8ca71f52cc879c1fa313d94547c9a0ddbd207977fe997f686a71e0c400
```

`cc-test-reporter` is ignored by the repo, so it want be pushed.

Same thing can be done on linux usign another binary code (see [documentation](https://docs.codeclimate.com/docs/configuring-test-coverage)). Besides the test coverage can be done automatically via Travis as well, but not on pull requests.

---



### Bug reporting
Please refer to this [guide](http://yourbugreportneedsmore.info).
If you need direct help you can join [Binda Slack Community](https://bindacms.slack.com).


### License
The gem is available as open source under the terms of the [GNU General Public License v3.0](https://github.com/a-barbieri/binda/blob/master/LICENSE).

### Credits
Binda is inspired by [Spina CMS](https://github.com/denkGroot/Spina).

We give also credit to authors and contributors of the gems that Binda uses. Huge thank you to all of them.

### Who is Binda?
Is [this guy here](https://en.wikipedia.org/wiki/Alfredo_Binda).

![Alfredo Binda 1927](https://www.dropbox.com/s/ktv8qo13zvoc9g4/Alfredo_Binda_1927.jpg?raw=1)


