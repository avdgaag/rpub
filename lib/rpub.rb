require 'optparse'
require 'fileutils'
require 'yaml'
require 'digest'
require 'ostruct'
require 'erb'

require 'builder'
require 'kramdown'
require 'zip/zip'

require 'rpub/version'
require 'rpub/subclass_tracker'
require 'rpub/commander'
require 'rpub/compilation_helpers'
require 'rpub/commands/base'
require 'rpub/commands/main'
require 'rpub/commands/compile'
require 'rpub/commands/clean'
require 'rpub/commands/preview'
require 'rpub/commands/package'
require 'rpub/commands/help'
require 'rpub/hash_delegation'
require 'rpub/book'
require 'rpub/chapter'
require 'rpub/compressor'
require 'rpub/epub'
require 'rpub/xml_file'
require 'rpub/epub/container'
require 'rpub/epub/toc'
require 'rpub/epub/content'
require 'rpub/epub/html_toc'
require 'rpub/epub/cover'

module Rpub
  GEM_ROOT = File.expand_path('../../', __FILE__)

  NoConfiguration = Class.new(StandardError)

  class InvalidSubcommand < StandardError
    def initialize(subcommand)
      super "Unknown subcommand: #{subcommand}"
    end
  end

  def self.support_file(path)
    File.join(GEM_ROOT, 'support', path)
  end

  KRAMDOWN_OPTIONS = {
    :coderay_line_numbers => nil
  }
end
