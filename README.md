# Purchasing

An API for Surfdome Purchasing built in Rails. Currently comes packaged with a frontend for
purchase processing built in React.

Originally brought to you by the [Made Tech team](https://github.com/madetech).

## Accessing the app

| env        | url                             | user       | password         |
| -----------|---------------------------------|------------|------------------|
| production | https://purchasing.surfdome.io  | purchasing | lastordersplease |
| staging    | https://purchasing.surfdome.cc  | purchasing | lastordersplease |

## Prerequisites

The Made Team are currently running this app inside our Vagrant env. This env
provides a few required dependencies listed below. Provided your dev env has
these you'll be okay.

 - Ruby (via rbenv preferably)
 - MySQL (setup as per config/database.yml or with config injected with DATABASE_URL)

## Developing

**Booting API for the first time**

```sh
cd api/
bundle install
bundle exec rake db:setup
bundle exec rails
```

**Reset your db**

```sh
bundle exec rake db:reset
```

**Booting frontend for the first time**

You're recommended to run the frontend outside of Vagrant or other virtualised environments. You may need some additional dependencies.

Install Homebrew if you don't already have it:
```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install node if you don't already have it:
```sh
brew install node
```

Rebuild node-sass:
```sh
npm rebuild node-sass
```

Finally you can install the local node packages:
```sh
cd processing_frontend/
npm install
```

**Developing frontend**

In one terminal run this to start API:

```sh
cd api/
bundle exec rackup -o 0.0.0.0 -p 3000
```

And in another to watch for JS/SCSS/Image changes run:

```sh
cd processing_frontend/
npm run watch
```

**Running tests locally**

```sh
cd api/
bundle exec rspec
```
