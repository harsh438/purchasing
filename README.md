# Purchasing

An API for Surfdome Purchasing built in Rails. Currently comes packaged with a frontend for
purchase processing built in React.

Originally brought to you by the [Made Tech team](https://github.com/madetech).

## Accessing the app

| env        | url                             | user       | password         |
| -----------|---------------------------------|------------|------------------|
| production | https://purchasing.surfdome.io  | purchasing | lastordersplease |
| staging    | https://purchasing.surfdome.cc  | purchasing | lastordersplease |

## Installation

* Clone this repo.
* Install the [Docker Toolbox](https://www.docker.com/docker-toolbox).
* Run the docker quickstart terminal (cmd-space should find it) to set up the VirtualBox VMs.
* Run `docker-machine start default` to start the VM.
* Run `eval $(docker-machine env default)` to bootstrap the env vars. Either add this line to your bashrc or run it in each new tab you open (For fish shell, use `eval (docker-machine env default)`).
* `cd` into `api/` and run `docker compose up`.
* Run `docker-compose run web rake db:create db:schema:load` in a new tab (you'll need to bootstrap the env vars here, too).

Gotchas:
* Instead of `bundle exec X`, use `docker-compose run web X` to run commands inside the container.
* Use `docker ps` to see running containers.
* To connect to the DB via sequel pro, run `docker-machine env default` and use the IP of the docker host, and use the port `13306`.
* To connect in the browser, use the docker host IP from the previous example at port 3000 (e.g. `http://192.168.99.100:3000/`).

## Developing

**Booting API for the first time**

```sh
cd api/
bundle install
bundle exec rake db:setup
bundle exec rails
```

Now import the [redacted dataset][redacted-data] to your local DB.

**Reset your DB**

```sh
bundle exec rake db:reset
```

Now import the [redacted dataset][redacted-data] to your local DB.

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
cd frontend/
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
cd frontend/
npm run watch
```

**Running tests locally**

```sh
cd api/
bundle exec rspec
```

[redacted-data]: https://drive.google.com/open?id=0BzNvNNGUQGxLUkJRTGRCaGJYMzQ
