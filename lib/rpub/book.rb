module Rpub
  # The Book object wraps a collection of chapter objects and knows about its
  # ordering, the book metadata from the configuration file and the book output
  # filename.
  class Book
    extend Forwardable
    include Enumerable

    def_delegators :@context, :fonts, :config, :layout

    # @return [Array<Chapter>] List of chapters, one for every input markdown file.
    attr_reader :chapters

    def initialize(context)
      @chapters = []
      @context = context
      @context.chapter_files.each(&method(:<<))
    end

    def each(&block)
      chapters.each(&block)
    end

    def has_fonts?
      fonts.any?
    end

    def has_toc?
      !!config.toc
    end

    def has_cover?
      !!config.cover_image
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
      @filename ||= [config.title, config.version].join('-').gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.epub'
    end
  end
end
