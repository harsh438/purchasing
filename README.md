# Purchasing

An API for Surfdome Purchasing built in Sinatra. Currently comes packaged with a frontend for
purchase processing built in React.

Originally brought to you by the [Made Tech team](https://github.com/madetech).

## Prerequisites

The Made Team are currently running this app inside our Vagrant env. This env
provides a few required dependencies listed below. Provided your dev env has
these you'll be okay.

 - Ruby (via rbenv preferably)
 - MySQL (setup as per app/database.rb)

## Developing

**Booting API for the first time**

```
cd api/
bundle install
bundle exec rackup -o 0.0.0.0 -p 3000
```

**Developing frontend**

In one terminal run:

```
cd api/
bundle exec rackup -o 0.0.0.0 -p 3000
```

And in another run:

```
cd processing_frontend/
npm run watch
```

**Running tests locally**

```
cd api/
bundle exec rspec
```
