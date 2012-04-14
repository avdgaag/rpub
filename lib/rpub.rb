require 'optparse'
require 'fileutils'
require 'builder'
require 'yaml'
require 'digest'

require 'kramdown'
require 'zip/zip'

require 'rpub/version'
require 'rpub/subclass_tracker'
require 'rpub/commander'
require 'rpub/commands/base'
require 'rpub/commands/main'
require 'rpub/commands/preview'
require 'rpub/commands/clean'
require 'rpub/commands/compile'
require 'rpub/book'
require 'rpub/chapter'
require 'rpub/compressor'
require 'rpub/epub'
require 'rpub/xml_file'
require 'rpub/epub/container'
require 'rpub/epub/toc'
require 'rpub/epub/content'

module RPub
  class InvalidSubcommand < StandardError
    def initialize(subcommand)
      super "Unknown subcommand: #{subcommand}"
    end
  end
end
