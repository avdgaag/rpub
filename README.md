# rPub -- an ePub generator in Ruby [![Build Status](https://secure.travis-ci.org/avdgaag/rpub.png?branch=master)](http://travis-ci.org/avdgaag/rpub)

**Note** this project is still in development and not yet ready for general use.

## Introduction

rPub is a command-line tool that generates a collection of plain text input
files into an eBook in ePub format. It provides several related functions to
make working with ePub files a little easier:

* Generation of table of contents
* Tracking of references to tables or figures
* Validation of output file
* Packaging your eBook in an archive with additional README file
* Very simple version control

## Installation

rPub is distributed as a Ruby gem, which should be installed on most Macs and
Linux systems. Once you have ensured you have a working installation of Ruby
and Ruby gems, install the gem as follows from the command line:

    $ gem install rpub

You can verify the gem has installed correctly by checking its version number:


    $ rpub -v

If this generates an error, something has gone wrong. You should see something
along the lines of `rpub 1.0.0`.

## Usage

### Basics

ePubs are basically collections of HTML files, combined in a single archive
according to a set of predefined rules. rPub generates these files for you from
simple text files written in [Markdown][], a very readable markup language created
by [John Gruber][]. This very README file is an example of a Markdown document.

The idea is you write several Markdown files using your favourite text editor,
and save them as plain text in your project directory. Usually you would write
one file per chapter. By invoking the `rpub` program you convert those files to
HTML and combine them in an ePub archive:

    $ rpub compile
    Generating my-new-book-0.1.0.epub... Done!

After you have run the `rpub compile` command, you will find a new `.epub` file
in your project directory. The name of this file depends on the title of your
book, and its version number. You can set these values, as well as a few others,
in a special configuration file called `config.yml`:

    ---
    author: Your Name
    title: My new book
    version: 0.1.0

This file is written in [YAML][] and sets basic properties of your book project.

To make sure the book you generated is _valid_ -- meaning it is likely that most
readers out there will be able to read it -- you can use the special `validate`
command:

    $ rpub validate

rPub will report any errors it finds. No output means everything is alright.

Since regenerating your ePub file and opening it in a suitable reader
application is cumbersome, rPub can generate a simple preview document for you:

    $ rpub preview

This will generate a new HTML file in your project directory with a name similar
to your ePub file. This is the entire text of your book as a single web page for
easy viewing in any browser.

[Markdown]: http://daringfireball.net/projects/markdown
[John gruber]: http://daringfireball.net

### Advanced features

#### Watching for changes

#### Packaging for distribution

#### Very simple version control

#### Automatic references

#### Automatic table of contents

#### Custom layout and styles

### Command reference

* `rpub compile` -- generate .epub file
* `rpub package` -- create zip file with compiled book and other listed files
* `rpub validate` -- compile, then validate
* `rpub preview` -- generate preview HTML file
* `rpub new` -- create skeleton directory tree
* `rpub help` -- get help on subcommands
* `rpub clean` -- remove generated files
* `rpub release` -- package and tag in Git
* `rpub snapshot` -- commit changes in git after validation

### Examples

See the [examples directory](https://github.com/avdgaag/rpub/example) for two example projects.

## Other

### Note on Patches/Pull Requests

1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests for it. This is important so I don't break it in a future version
   unintentionally.
4. Commit, do not mess with rakefile, version, or history. (if you want to have
   your own version, that is fine but bump version in a commit by itself I can
   ignore when I pull)
5. Send me a pull request. Bonus points for topic branches.

### Issues

Please report any issues, defects or suggestions in the [Github issue
tracker](https://github.com/avdgaag/rpub/issues).

### What has changed?

See the [HISTORY](https://github.com/avdgaag/rpub/HISTORY) file for a detailed changelog.

### Credits

Created by: Arjan van der Gaag  
URL: [http://arjanvandergaag.nl](http://arjanvandergaag.nl)  
Project homepage: [http://avdgaag.github.com/rpub](http://avdgaag.github.com/rpub)  
Date: april 2012  
License: [MIT-license](LICENSE) (same as Ruby)
