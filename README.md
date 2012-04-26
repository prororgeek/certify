

[![Build Status](https://secure.travis-ci.org/dei79/certify.png)](http://travis-ci.org/dei79/certify)

certify
=======

Certify is a Ruby on Rails / OpenSSL based CA engine which can be mounted in every rails application of your choice!

Installation
============

add to your Gemfile: gem 'certify', :git => 'git://github.com/dei79/certify.git'

install our migrations: rake certify_engine:install:migrations

migrate your db: rake db:migrate

Start using it
==============

check if the engine is available: rake routes

Add before_filter to our controllers (e.g. access check)
========================================================

add a certify initializer in your app (certify.rb) with the following content (replace :backend_rights_required with your handler):

[certify.rb](https://gist.github.com/2483757 "Adding before_filter_handler")
