module RPub
  class Book
    include Enumerable
    include HashDelegation

    delegate_to_hash :config

    attr_reader :config, :chapters, :layout

    def initialize(config = {}, layout)
      @chapters, @config, @layout = [], config, layout
    end

    def each
      chapters.each { |c| yield c }
    end

    def add_chapter(chapter)
      chapters << Chapter.new(chapter, chapters.size, layout)
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
