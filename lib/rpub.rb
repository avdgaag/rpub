require 'optparse'
require 'fileutils'
require 'yaml'
require 'digest'
require 'ostruct'
require 'erb'
require 'forwardable'

require 'builder'
require 'kramdown'
require 'zip'
require 'nokogiri'
require 'textstats'
require 'typogruby'

module Rpub
  GEM_ROOT = File.expand_path('../../', __FILE__)

  # @return [String] full path to a file that was relative to the gem support directory
  def self.support_file(path)
    File.join(GEM_ROOT, 'support', path)
  end

  def self.source
    FilesystemSource
  end

  def self.document_factory
    Rpub::Document.method(:new)
  end
end

require 'rpub/version'
require 'rpub/filesystem_source'
require 'rpub/context'
require 'rpub/command'
require 'rpub/commands/clean'
require 'rpub/commands/compile'
require 'rpub/commands/generate'
require 'rpub/commands/package'
require 'rpub/commands/preview'
require 'rpub/commands/stats'
require 'rpub/hash_delegation'
require 'rpub/book'
require 'rpub/preview'
require 'rpub/chapter'
require 'rpub/compressor'
require 'rpub/epub'
require 'rpub/xml_file'
require 'rpub/epub/container'
require 'rpub/epub/toc'
require 'rpub/epub/content'
require 'rpub/epub/html_toc'
require 'rpub/epub/cover'
require 'rpub/media_type'
require 'rpub/document'
