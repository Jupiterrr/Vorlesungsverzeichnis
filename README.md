# Vorlesungsverzeichnis [![Build Status](https://travis-ci.org/Jupiterrr/Vorlesungsverzeichnis.png?branch=master)](https://travis-ci.org/Jupiterrr/Vorlesungsverzeichnis) [![Code Climate](https://codeclimate.com/github/Jupiterrr/Vorlesungsverzeichnis.png)](https://codeclimate.com/github/Jupiterrr/Vorlesungsverzeichnis)
[www.kithub.de](http://www.kithub.de)

For students of the [Karlsruhe Institute of Technology](http://www.kit.edu).



## Streamlined setup

**With the help of docker and our `./d` tool it should be easy to run this application without any knowledge of Rails or Ruby.** All dependecies are installed into docker containers, thus nothing will mess up your system, and everything needed to getting started will be set up for you.


### <a id="osx"></a> Mac OS X

1. Install [boot2docker](http://boot2docker.io/)
	
	The installer of boot2docker will install everything you need (i.e. [VirtualBox](https://www.virtualbox.org/) and [docker](https://github.com/docker/docker)).
	Docker depends on Linux so everything has to run inside a VM.

2. Run `boot2docker init`
	
3. Run `./d sync`

	boot2docker uses very slow shared folders. For faster file access inside the VM you can use the `./d sync` command that syncs all files into the VM. For it to keep all files synchronized, it needs to run all the time.   

4. Run `./d init`

#### Alternative:

You can run this Rails app natively on your Mac, but you have to figure out how to install everything yourself. It shouldn't be too hard, if you're already familiar with Rails.


### <a id="linux"></a>Linux

1. [Install docker](https://docs.docker.com/installation/#installation)

2. Clone this project 
	```
	git clone https://github.com/Jupiterrr/Vorlesungsverzeichnis.git
	cd Vorlesungsverzeichnis
	```
3. Run `./d init`



### Windows

The installation process should be similar to that for [Mac OS X](#osx).
I haven't tried though.


### Digital Ocean

You can get KitHub running within minutes on [Digital Ocean](https://www.digitalocean.com/).
Just create a new instance and select the Docker Image under Application. Connect to it via SSH (username is *root*).
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
> Copyright © 2014 Carsten Griesheimer (hallo@carstengriesheimer.de)
