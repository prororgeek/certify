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

Override controller logic (e.g. for access check)
=================================================

To add something to our standard controllers just override them in your main app. Please ensure that you are using the right namespace. A sample of my application which allows access to this controllers only when the current user has backend admin rights:

class Certify::AuthoritiesController < ApplicationController
  before_filter :backend_rights_required
end

class Certify::CertificatesController < ApplicationController
  before_filter :backend_rights_required
end
