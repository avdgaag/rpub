# History

## (unreleased)

* Respect `max_level` setting in human-readable table of contents
* Use default configuration when no `config.yml` file can be found
* Allow passing in custom configuration file in `compile` command with -c option
* Bugfix: count ePub table of contents order from 1, not from 0
* Output `clean` command warnings on stderr, not stdout
* Round readability statistics from `stats` command
* Bugfix: let `stats` command consider less than one page still one page, not 0 pages

## 0.4.0

* Generate ePub table of contents from markdown headings
* Expanded documentation with configuration reference
* Enhanced .mobi compatibility (convert your .epub with kindlegen)

## 0.3.0

* Only run simplecov on demand
* Automatically find and include embedded fonts
* Filter input through typogruby
* Added stats commands

## 0.2.1

* Bugfix: allow multiple headings per chapters in outline
* Bugfix: use correct id method, renamed to xml_id
* Various documentation improvements
* Added MIT license
* Added code coverage reports (Ruby 1.9 only)
* Improved test suite

## 0.2.0

* Prefixed book query methods with `has_?`
* Added generate command
* Use inline styles for preview file
* Allow font embedding
* Improved tests
* Remove mention of validate command

## 0.1.0

* Initial gem release
