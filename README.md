Ricotta is a web based translation management tool, with complimentary build 
tools, to efficiently manage localized resources in your software project.

- http://ricotta-open.appspot.com
- https://github.com/sosandstrom/ricotta

## About

The ricotta gem integrates with the Ricotta translation tool to make it easier
to keep translations up to date in your software projects, all from the command line.

## Installation

    gem install ricotta

## Usage

    $ ricotta
    
    Download translations from Ricotta
    
    Commands:
    dump                 Dump translations from Ricotta into local files.
    help                 Display global or [command] help documentation.
    install:xcode        Fetch translations from Ricotta and install them into an Xcode project

    Global Options:
    -h, --help           Display help documentation 
    -v, --version        Display version information 
    -t, --trace          Display backtrace when an error occurs 

### Install into an Xcode project

    $ cd projects/MyXcodeProject
    $ ricotta install:xcode -u http://ricotta-open.appspot.com \
                            -p MyRicottaProject \
                            -l en

Or by recommendation, create a `.ricottarc` file (see below) and execute.

    $ ricotta install:xcode

## Configuration

You can configure ricotta by using a ricotta configuration file. 
The recommended name is `.ricottarc` but a custom file can be passed by using the `-c` option.

    # My Ricotta configuration
    url: http://ricotta-open.appspot.com
    project: MyProject
    language: en,es,pt
    branch: staging
    template: my_translation_template

Ricotta automatically searches for `.ricottarc` in the current working directory and in the users home directory.
Multiple configurations are automatically merged.

Multiple configurations example:

    # Global config in ~/.ricottarc
    url: http://ricotta.mycompany.com
    subset: ios

App configurations

    # /Users/es/dev/projects/MyiOSApp
    project: MyApp
    language: en,es
    name_token: appName
    
And

    # /Users/es/dev/projects/MyOtheriOSApp
    project: MyOtherApp
    language: en,pt,ru
    name_token: applicationName
    subset: iphone  #override global config
    
## Contact

Erik Sundin

- erik@eriksundin.se
 
## License

Ricotta gem is available under the MIT license. See the LICENSE file for more info.
