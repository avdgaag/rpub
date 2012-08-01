module Rpub
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

    OutlineElement = Struct.new(:level, :text, :html_id)

    def initialize(content, number, layout)
      @content, @number, @layout = content, number, layout
      @document = Kramdown::Document.new(content, KRAMDOWN_OPTIONS.merge(:template => layout))
    end

    # @return [Kramdown::Element] Toc elements hierarchy
    def toc
      Kramdown::Converter::Toc.convert(@document.root).first
    end

    # @return [String] Unique identifier for this chapter.
    def uid
      @uid ||= Digest::SHA1.hexdigest([content, xml_id.to_s, layout].join)
    end

    # @return [String] XML-friendly slug for this chapter based on its number.
    def xml_id
      @id ||= "chapter-#{number}"
    end

    # @return [String] content parsed to HTML by the markdown engine.
    def to_html
      @to_html ||= Typogruby.improve(@document.to_html)
    end

    # @return [String] name for the file in the zip to use, based on the title
    def filename
      @filename ||= xml_id.to_s + '-' + title.gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.html'
    end

    # Ordered headers for this chapter, each header as an object responding
    # to #level and #text.
    #
    # @return [Array<#text,#level,#html_id>] list of headers for this chapter
    def outline
      @outline ||= elements(:header).map do |element|
        OutlineElement.new(
          element.options[:level],
          element_text(element),
          Kramdown::Converter::Html.send(:new, @document, { :auto_id_prefix => '' }).generate_id(element.options[:raw_text])
        )
      end
    end

    # @return [Array<String>] list of all image references
    def images
      @images ||= elements(:img).map { |e| e.attr['src'] }
    end

    # @return [String] Text of the first heading in this chapter
    def title
      @title ||= begin
        (heading = outline.first) ? heading.text : 'untitled'
      end
    end

  private

    def element_text(element)
      elements(:text, element).map { |e| e.value }.join
    end

    def elements(type, root = @document.root)
      collector = lambda do |element|
        element.children.select { |e|
          e.type == type
        } + element.children.map { |e|
          collector.call(e)
        }.flatten
      end
      collector.call(root)
    end
  end
end
