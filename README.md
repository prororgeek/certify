

[![Build Status](https://secure.travis-ci.org/dei79/certify.png)](http://travis-ci.org/dei79/certify)

certify
=======

Certify is a Ruby on Rails / OpenSSL based CA engine which can be mounted in every rails application of your choice!

Installation
============

gem install certify or update your Gemfile

rake certify:install:migrations

rake db:migrate

Start using it
==============

Just mount the engine into your app with adding the following code to routes.rb of your rails app: mount Certify::Engine => "/certify"

Don't forget to use in shared layout view helpers as follows: main_app.root_url!
