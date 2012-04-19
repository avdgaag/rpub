module Rpub
  # The Book object wraps a collection of chapter objects and knows about its
  # ordering, the book metadata from the configuration file and the book output
  # filename.
  class Book
    include Enumerable
    include HashDelegation

    delegate_to_hash :config

    # @return [Hash] The hash of configuration options read from the config.yml file.
    attr_reader :config

    # @return [Array] List of chapters, one for every input markdown file.
    attr_reader :chapters

    # @return [String] the path the layout HTML file to use to wrap the chapter in.
    attr_reader :layout

    def initialize(layout, config = {})
      @chapters, @config, @layout = [], config, layout
    end

    def each(&block)
      chapters.each(&block)
    end

    def toc?
      !!config.fetch('toc') { false }
    end

    def cover?
      !!config.fetch('cover_image') { false }
    end

    def outline
      inject([]) { |all, chapter| all << [chapter.filename, chapter.outline] }
    end

    def images
      map { |chapter| chapter.images }.flatten.uniq
    end

    # Add textual content as a new Chapter to this book.
    #
    # This method returns the `Book` object iself, so you can chain multiple calls:
    #
    # @example Chaining mutliple calls
    #   book << 'foo' << 'bar'
    #
    # @param [String] content is chapter text to add
    def add_chapter(content)
      chapters << Chapter.new(content, chapters.size, layout)
      self
    end
    alias_method :<<, :add_chapter

    # @return [String] Unique identifier for this entire book to be used in the
    #   epub manifest files.
    def uid
      @uid ||= Digest::SHA1.hexdigest [config.inspect, map(&:uid)].join
    end

    # @return [String] output filename for epub, based on the book title and
    #   version number.
    def filename
      @filename ||= [config['title'], config['version']].join('-').gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.epub'
    end
  end
end
