# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Run the below commands:
rails db:create
rails db:migrate

rails generate devise:install
rails generate devise:views users



brew install elasticsearch
brew services start elasticsearch



rake searchkick:reindex CLASS=Upload
