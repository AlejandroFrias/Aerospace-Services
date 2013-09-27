Aerospace-Services

Author: Alejandro Frias
Created: 20 September 2013
Last Updated: 27 September 2013

Version: -1
==================

Team members:
	Vivian Wehner
	Alejandro Frias
	Sean Adler

Our services for aerospace clinic project 2013 will be hosted and
developed using Ruby on Rails.

Ruby Verion Manager: 1.22.10
Ruby version:        2.0.0
Rails version:       4.0.0

How to install on mac (windows is mor difficult):
	1. \curl -L https://get.rvm.io | bash (installs Ruby Version Manager)
	2. rvm install 2.0.0 (uses rvm to install Ruby)
	3. ruby install rails (uses ruby to install rails)
  4. check that version match (rvm -v, ruby -v, rails -v)

How to setup database:
  0. rake db:drop (delete the table if you need to restart)
  1. rake db:create
  2. rake db:migrate
  3. rake db:seed



If you get the follwing error, here's the fix. It has to do with mysql:

FIX:
$> sudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib

ERROR:
rake aborted!
dlopen(/Users/alejandrofrias/.rvm/gems/ruby-2.0.0-p247/gems/mysql2-0.3.13/lib/mysql2/mysql2.bundle, 9): Library not loaded: libmysqlclient.18.dylib
  Referenced from: /Users/alejandrofrias/.rvm/gems/ruby-2.0.0-p247/gems/mysql2-0.3.13/lib/mysql2/mysql2.bundle
  Reason: image not found - /Users/alejandrofrias/.rvm/gems/ruby-2.0.0-p247/gems/mysql2-0.3.13/lib/mysql2/mysql2.bundle


Guides for Ruby: http://guides.rubyonrails.org/
