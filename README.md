TenderSwift is a cutting-edge web application designed specifically for construction companies. It streamlines the process of sending out, receiving, and evaluating requests for tenders. By automating these processes, TenderSwift not only saves hours of manual labor but also significantly reduces the risk of costly errors.

## Key Features

- **Automated Tender Management**: Send out and receive tenders with just a few clicks.
- **Unified Dashboard**: View and manage all tenders from a single, intuitive dashboard.
- **Error Reduction**: Advanced algorithms ensure that errors, which could cost thousands of dollars, are minimized.
- **Integration with Spreadsheets**: Easily combine data from multiple contractors without the hassle of manual data entry.
- **Secure**: Built with the latest security standards to ensure your data is safe and protected.


## Getting Started

This project was created [Ruby On Rails 5]
(https://guides.rubyonrails.org)

Below you'll find information on how to set the project up on your local machine. <br>



## System Dependencies


### Update and install dependencies
First, we should update apt-get since this is the first time we will be using apt in this session. This will ensure that the local package cache is updated.

Run `sudo apt-get update`

Now let's install the dependencies required for rbenv and Ruby with *[`apt-get`] : 
`sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev` in your terminal


### Install Rbenv
Now we are ready to install rbenv. Let's clone the rbenv repository from git. You should complete these steps from the user account from which you plan to run Ruby.

`git clone https://github.com/rbenv/rbenv.git ~/.rbenv`

From here, you should add *[`~/.rbenv/bin`] to your $PATH so that you can use rbenv's command line utility. Also adding *[`~/.rbenv/bin/rbenv`] init to your *[`~/.bash_profile`] will let you load rbenv automatically.

`echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc`
`echo 'eval "$(rbenv init -)"' >> ~/.bashrc`

Next, source rbenv by typing:

`source ~/.bashrc`

You can check to see if rbenv was set up properly by using the type command, which will display more information about rbenv:

`type rbenv`

Output:

```
rbenv is a function
rbenv () 
{ 
    local command;
    command="$1";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in 
        rehash | shell)
            eval "$(rbenv "sh-$command" "$@")"
        ;;
        *)
            command rbenv "$command" "$@"
        ;;
    esac
}
```
In order to use the rbenv install command, which simplifies the installation process for new versions of Ruby, you should install ruby-build, which we will install as a plugin for rbenv through git:

`git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`


### Install Ruby
With the ruby-build rbenv plugin now installed, we can install whatever versions of Ruby that we may need through a simple command. First, let's list all the available versions of Ruby:

`rbenv install -l`

Let's install Ruby version 2.4.1, and once it's done installing, we can set it as our default version with the global sub-command:

`rbenv install 2.4.1`
<br>
`rbenv global 2.4.1`

Verify that Ruby was properly installed by checking your version number:

`ruby -v`

**Minimum version required is ruby 2.4.x**


### Install Rails
As the same user, you can install the most recent version of Rails with the gem install command:

`gem install rails --version=5.0`

rbenv works by creating a directory of shims, which point to the files used by the Ruby version that's currently enabled. Through the rehash sub-command, rbenv maintains shims in that directory to match every Ruby command across every installed version of Ruby on your server. Whenever you install a new version of Ruby or a gem that provides commands, you should run:

`rbenv rehash`

Verify that Rails has been installed properly by printing its version, with this command:

`rails -v`


### Install JavaScript Runtime

A few Rails features, such as the Asset Pipeline, depend on a JavaScript Runtime. We will install Node.js to provide this functionality.

We can first move to a writable directory such as /tmp. From there, let's verify the Node.js script by outputting it to a file, then read it with less:

`cd /tmp`
`\curl -sSL https://deb.nodesource.com/setup_4.x -o nodejs.sh`
`less nodejs.sh`

Once we are satisfied with the Node.js script, we can install the NodeSource Node.js v4.x repo:
`cat /tmp/nodejs.sh | sudo -E bash -`

The -E flag used here will preserve the user's existing environment variables.

Now we can use *[`apt-get`] to install Node.Js:
`sudo apt-get install -y nodejs`

**Minimum version required is v4.x**


### Install Postgres  
Run `sudo apt-get install postgresql postgresql-contrib` <br>
**Minimum version required is 9**


### Setup the app
Install the needed gems
`bundle install`

Create the database
`rails db:create`

Run the migrations for the database
`rails db:migrate`

Run the test suite to verify that everything is working correctly
`bundle exec rspec`

If the test suite passes, you'll be ready to run the app in a local server:
`rails server`

Now navigate to navigate to [http://localhost:3000](http://localhost:3000) in your browser to see the application


TenderSwift - Streamlining Construction Tenders, One Project at a Time.
