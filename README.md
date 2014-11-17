# Vorlesungsverzeichnis [![Build Status](https://travis-ci.org/Jupiterrr/Vorlesungsverzeichnis.png?branch=master)](https://travis-ci.org/Jupiterrr/Vorlesungsverzeichnis) [![Code Climate](https://codeclimate.com/github/Jupiterrr/Vorlesungsverzeichnis.png)](https://codeclimate.com/github/Jupiterrr/Vorlesungsverzeichnis)
[www.kithub.de](http://www.kithub.de)

For students of the [Karlsruher Institut für Technologie](http://www.kit.edu).



## Streamlined setup

**With the help of docker and our `./d` tool it should be easy to run this application without any knowledge of rails or ruby.** Although all dependecies are install into docker containers and nothing will mess up you system and everything needed to getting startet will be set up for you.


### <a id="osx"></a> Mac OS X

1. Install [boot2docker](http://boot2docker.io/)
	
	The installer of boot2docker will install everything we need (virtualbox, docker).
	Docker depends on Linux so everything have to run inside a vm.

2. Run `boot2docker init`
	
3. Run `./d sync`

	The shared folders boot2docker uses are too slow for us. For faster file access inside the vm you can use the `./d sync` command that syncs all files into the vm. It has to run all the time to sync changed files.   

4. Run `./d init`

#### Alternative:

You can run this rails app on your mac natively, but you have to figure out how to install everything yourself. It's not too hard if you're already familiar with rails.


### <a id="linux"></a>Linux

1. [Install docker](https://docs.docker.com/installation/#installation)

2. Clone this project 
	```
	git clone https://github.com/Jupiterrr/Vorlesungsverzeichnis.git
	cd Vorlesungsverzeichnis
	```
3. Run `./d init`



### Windows

Something like [the stept of Mac OS X](#osx) should work. I don't know.


### Digital Ocean

You can get KitHub running within minutes on [Digital Ocean](digitalocean.com). 
Just create a new instance and select the Docker Image under Apllication. SSH to it (username is *root*).
At this point you can follow the [Linux instructions](#linux).


## Built With
- [Ruby on Rails](https://github.com/rails/rails) - Our back end is a Rails app.
- [PostgreSQL](http://www.postgresql.org/) - Our main data store is in Postgres.
- [Heroku](http://heroku.com/) - Our hosting platform is Heroku.

<!---
## Documentation
[Tomdoc](http://tomdoc.org/)
--->

<!---
## Testing
### Unit Tests
For testing we use rspec.
You can find more information about rspec here:

* [Relishapp - Documentation RSpec Core 2.4](https://www.relishapp.com/rspec/rspec-core/v/2-4/docs)
* [Rubydoc - RSpec Core](http://rubydoc.info/gems/rspec-core)

### Feature Tests
Every feature that the user faces and driectly interact with should be tested. We use cucumber for these kind of tests. You can find them in `features/`.

Cucumber is faily easy to use. Just write the test in plain english like the existing ones and run cucumber. It will tell you what to do.

To run these test type
```
$ script/cucumber [File]
```

When you run test with the @javascript tag cucumber will use phantomjs and won't print an helpful error messag or backtrace for 500 Internal Server Errors.
With a little hack you can now find the proper error message in `log/diagnostic.log`.
But most often you can easily reproduce the error in your development environment.
--->

## Author
Carsten Griesheimer:
[Twitter](https://twitter.com/jupiterrrr),
[Github](https://github.com/Jupiterrr),
[Personal page](http://carstengriesheimer.de)

## Copyright / License
> Copyright © 2013 Carsten Griesheimer (hallo@carstengriesheimer.de)
