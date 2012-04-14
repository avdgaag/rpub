module RPub
  class Book
    include Enumerable

    attr_reader :config, :chapters

    def initialize(config = {})
      @chapters, @config = [], config
    end

    def respond_to?(m)
      super || config.has_key?(m.to_s)
    end

    def method_missing(m, *args, &block)
      return super unless respond_to? m
      config.fetch m.to_s
    end

    def each
      chapters.each { |c| yield c }
    end

    def add_chapter(chapter)
      chapters << Chapter.new(chapter, chapters.size)
    end
    alias_method :<<, :add_chapter

    def uid
      @uid ||= Digest::SHA1.hexdigest [config.inspect, map(&:uid)].join
    end

    def filename
      @filename ||= [config['title'], config['version']].join('-').gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.epub'
    end
  end
end
