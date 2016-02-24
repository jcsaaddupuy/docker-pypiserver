docker-pypiserver
=================

pypiserver in a box


*with additions from Fred Thiele <ferdy_news@gmx.de>*


# Quick start

## Launch the server

    mkdir -p /tmp/pypi/packages
    docker run -p 8080:8080 -v /tmp/pypi/packages:/data/packages jcsaaddupuy/pypiserver

## Default config

The image comes with a default account :

- login : admin
- password : password

## Configure setup tools

In ~/.pypirc, add the following content :

    [distutils]
    index-servers =
      internal

      [internal]
      repository: http://127.0.0.1:8080
      username: admin
      password: password

## Upload  your first package

```
python setup.py sdist upload -r internal
```

You can now browse to [http://localhost:8080/simple](http://localhost:8080/simple)
to browse availables packages



# Advanced usage

The image starts with pypi-server as main entry point, configured to use the
.htaccess (see Dockerfile for details). You can pass any pypi-server option when
running the container.

See [schmir/pypiserver](https://github.com/schmir/pypiserver) for all availables
options.

## Enable package overwriting

Simply pass the _-o_ option :

    docker run -p 8080:8080 -v /tmp/pypi/packages:/data/packages jcsaaddupuy/pypiserver -o


## Use custom accounts
First, generate a custom .htaccess file :

    htpasswd -sc /path/to/config/.htaccess account_name

Then, start the container with the folder containing the config mounted as
/home/pypiserver/config :

    docker run -p 8080:8080 -v /tmp/pypi/packages:/data/packages -v /path/to/config:/config jcsaaddupuy/pypiserver

## Use with tox

in tox.ini, add your server in the __indexserver__ section :

    [tox]
    indexserver =
        default = https://pypi.python.org/simple
        DEV = http://127.0.0.1:8080/simple

You can then use your own server pypi server to install dependancies, by
prefixing the modulename with the alias given in indexserver (in our case, :DEV:) :

    [testenv]
    deps= :DEV:your_awesome_module


