# Rpub -- an ePub generator in Ruby [![Build Status](https://secure.travis-ci.org/avdgaag/rpub.png?branch=master)](http://travis-ci.org/avdgaag/rpub)

## Introduction

Rpub is a command-line tool that generates a collection of plain text input
files into an eBook in ePub format. It provides several related functions to
make working with ePub files a little easier:

* Generation of table of contents
* Packaging your eBook in an archive with additional README file
* Embedding fonts
* Easy previewing as you write
* .mobi compatibility

## Installation

Rpub is distributed as a Ruby gem, which should be installed on most Macs and
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
according to a set of predefined rules. Rpub generates these files for you from
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

This file is written in [YAML](http://yaml.org) and sets basic properties of
your book project.

Since regenerating your ePub file and opening it in a suitable reader
application is cumbersome, Rpub can generate a simple preview document for you:

    $ rpub preview

This will generate a new HTML file in your project directory with a name similar
to your ePub file. This is the entire text of your book as a single web page for
easy viewing in any browser.

[Markdown]: http://daringfireball.net/projects/markdown
[John gruber]: http://daringfireball.net

### Generating a .mobi file

Since the ePub and Mobipocket file formats are very (_very_) similar it is
quite easy to create a `.mobi` version of your book, suitable for reading on
Amazon's Kindle. To do so, you will need to install the [kindlegen program
Amazon provides][kindlegen].

Here's how it works:

1. Install `kindlegen` ([download it here][kindlegen])
2. Compile your book as usual using `rpub compile`
3. Compile `my-book.epub` to `my-book.mobi`: `kindlegen my-book.epub`.

Optionally, include your `my-book.mobi` in your package by adding it to your
list of packaged files (see "Packaging for distribution").

[kindlegen]: http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211

### Advanced features

#### Packaging for distribution

Often you want to distribute your ebook over the internet, along with some
extra files. You'll probably want to include a README file, a license or
references to extra online resources. A `package` task is defined to generate a
single compressed archive file from your generated ebook along with such
additional files.

You list the files to include with your ebook in your `config.yml` file, along
with the resulting packaged file name:

    ---
    package_file: mybook.zip
    package:
      - README
      - license.txt
      - code-samples.rb

All the filenames listed under `package` are looked up in the root of your
project directory. These files will be combined with the ebook in the
`mybook.zip` file in your project directory.

#### Automatic table of contents

Rpub automatically generates a table of contents for you, if you want it to. It
does this by scanning all your markdown files for headings and listing them on
a single page in the ebook. Each entry in the table of contents is linked to
its appropriate heading in the chapter, and has various hooks for your
stylesheet to determine its formatting.

To enable the automatic generation of a table of contents, add the following
configuration to your `config.yml` file:

    toc: true

Note that this only affects the human-readable table of contents, represented
as a page in your book. Rpub will alway generate the .epub table of contents
for you, which contains the machine-readable references to your chapters. It
will, by default, reference all chapter titles and subheadings for you, but
you can customize the number of levels that will be included using the
following in your `config.yml` file:

    max_level: 3

#### Custom layout and styles

When you compile a set of Markdown files to an ePub file, rpub uses a default
HTML layout and set of styles to determine the look and feel of the book. These
will do fine for most cases, but you can provide your own, if you are so
inclined.

Simply define a `layout.html` and/or `styles.css` in your project directory.
Your HTML file will be parsed with Erb, an so you can include your writing
using the `@body` instance variable:

    <html>
    <body>
      <%= @body %>
    </body>
    </html>

**Note 1**: this feature is actually provided by the [Kramdown gem][kramdown],
so have a look at [the standard Kramdown document template][doc] to see some
nifty tricks.

[kramdown]: http://kramdown.rubyforge.org
[doc]:      https://github.com/gettalong/kramdown/blob/master/data/kramdown/document.html

**Note 2**: despite the name 'html' and `.html` extension, your file actually has
to be XHTML-compliant.

You can also provide custom layouts or styles to use when invoking the `compile`
or `preview` commands, using the `-l` or `-s` options:

    $ rpub compile -l /tmp/my-layout.html

If you like the default layout or styles, but want to adapt them, you can copy
those files into your project using the `generate` subcommand:

    $ rpub generate

### Command reference

`rpub compile`
: generate .epub file

`rpub package`
: create zip file with compiled book and other listed files

`rpub preview`
: generate preview HTML file

`rpub generate`
: copy default layout.html, styles.css and config.yml

`rpub help`
: get help on subcommands

`rpub clean`
: remove generated files

### Configuration reference

`title`
: the book title (string)

`descrption`
: one-line summary of the book (string)

`creator`
: author name (string)

`publisher`
: publisher name (string)

`subject`
: book subject/category (string)

`language`
: language code of the book contents, e.g. 'en' (string)

`rights`
: copyright line (string)

`version`
: version number of the book to include in the .epub filename (string)

`toc`
: whether to generate a table of contents as book page (boolean, default false)

`max_level`
: the maximum depth of the .epub table of contents (number, default 2)

`ignore`
: list of files not to include in the epub, that otherwise would (array)

`package`
: list of files to be included in the archive created by the package task (array)


### Examples

See the [examples directory](https://github.com/avdgaag/rpub/tree/master/example) for two example projects.

### Documentation

See the inline [API docs](http://rubydoc.info/github/avdgaag/rpub/master/frames) for more information.

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

See the [HISTORY](https://github.com/avdgaag/rpub/blob/master/HISTORY.md) file for a detailed changelog.

### Credits

Created by: Arjan van der Gaag  
URL: [http://arjanvandergaag.nl](http://arjanvandergaag.nl)  
Project homepage: [http://avdgaag.github.com/rpub](http://avdgaag.github.com/rpub)  
Date: april 2012  
License: [MIT-license](https://github.com/avdgaag/rpub/LICENSE) (same as Ruby)
