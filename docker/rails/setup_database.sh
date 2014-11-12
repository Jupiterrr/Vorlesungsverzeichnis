#!/bin/bash
bundle exec rake db:drop db:create db:restore db:migrate
