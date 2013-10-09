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

Provided Services:

  1. A list of buildings given lat, long, and range:
    hmcbuildings.herokuapp.com/?latitude=YOUR_LAT&longitude=YOUR_LONG&range=YOUR_RANGE

SETUP instruction:

Guides for Ruby: http://guides.rubyonrails.org/

Ruby Verion Manager: 1.22.10
Ruby:  2.0.0
Rails: 4.0.0

MySQL: 5.0
MySQL Workbench: 6.0.7

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

Use wifi Claremont-ETC (password: bbccddeeff) for local testing.

How to use/setup MySQL Workbench:
 SETUP:
  1. First make sure MySQl server is running in System Preferences (at the bottom).
  2. Make a connection (a '+' sign next to MySQL Connections on home)
  3. Test the connection at the bottom (it should say Test Connection)
  4. Name the connection (whatever you like, leave the rest default)
 USE:
  1. You should see the available databases on the left, under SCHEMAS.
  2. In the main SQL file type "use database_name;" where database_name is the name of the development database you see available (which is hmcBuildingService_development if you are using that)
  3. COMMAND + ENTER or the lighting icons will run any mysql commands you enter. You can even edit the table that pops up from a SELECT query and it will create the correct SQL commands to incorporate the change and let you run them. This includes creating/deleting rows (or entries)
