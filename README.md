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
* Now follow the development information below

## Developing

**Updating gems**

```
docker-compose build
```

Now run the following in another tab to setup your DB:

```
docker-compose run web rake db:setup
```

**Booting the project for the first time**

```sh
docker-compose up
```

This will boot the rails server. To connect in the browser, visit the docker
host IP at port 3000 (e.g. `http://192.168.99.100:3000/`). To find out the IP
simply run:

```
docker-compose env default
```

Now import the [redacted dataset][redacted-data] to your local DB. We usually
do this using SequelPro connected to your docker DB instance. To connect to the
DB via sequel pro, run `docker-machine env default` and use the IP of the docker
host, and use the port 13306.

**Reset your DB**

```sh
docker-compose run web rake db:reset
```

Now import the [redacted dataset][redacted-data] to your local DB.

**Developing frontend**

In order to build the app and watch for changes you make, run

```sh
  npm run dev
```

The first build takes a bit of time but subsequent builds will be faster.

**Running tests locally**

```sh
docker-compose run web rspec
```

**Running entire build locally**

```sh
docker-compose run web rake build
```

## Advanced mode

Staff who require advanced mode can add a bookmark with the following URL:

```
javascript:void(window.store.dispatch({ type: 'ADVANCED_MODE' }));
```

Clicking this whilst looking at the purchasing app will enable advanced
features.

[redacted-data]: https://drive.google.com/open?id=0BzNvNNGUQGxLUkJRTGRCaGJYMzQ
