module RPub
  # Representation of a chapter in the book, from a single input file from the
  # project directory.  The Chapter object knows how to turn itself into HTML
  # suitable for writing to the epub archive with the appropriate identifiers
  # to be listed in the epub manifest files.
  class Chapter
    # @return [String] raw textual contents of this chapter
    attr_reader :content

    # @return [Fixnum] chapter number provided by its associated Book object
    attr_reader :number

    # @return [String] filename of the layout to use, to be passed directly to the Kramdown gem.
    attr_reader :layout

    def initialize(content, number, layout)
      @content, @number, @layout = content, number, layout
      @document = Kramdown::Document.new(content, KRAMDOWN_OPTIONS.merge(:template => layout))
    end

    # @return [String] Unique identifier for this chapter.
    def uid
      @uid ||= Digest::SHA1.hexdigest([content, id.to_s, layout].join)
    end

    # @return [String] XML-friendly slug for this chapter based on its number.
    def id
      @id ||= "chapter-#{number}"
    end

    # @return [String] content parsed to HTML by the markdown engine.
    def to_html
      @to_html ||= @document.to_html
    end

    # @return [String] name for the file in the zip to use, based on the title
    def filename
      @filename ||= id.to_s + '-' + title.gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.html'
    end

    # @return [String] Text of the first heading in this chapter
    def title
      @title ||= begin
        h = @document.root.children.find { |c| c.type == :header }
        return 'untitled' unless h
        collector = lambda do |c|
          c.children.collect do |cc|
            if cc.type == :text
              cc.value
            else
              collector.call cc
            end
          end.join ''
        end
        title = collector.call(h) || 'untitled'
      end
    end
  end
end
