module Rpub
  class Document
    KRAMDOWN_OPTIONS = {
      :coderay_line_numbers => nil
    }

    OutlineElement = Struct.new(:level, :text, :html_id)

    def initialize(content, layout)
      @document = Kramdown::Document.new(content, KRAMDOWN_OPTIONS.merge(:template => layout))
    end

    # @return [Kramdown::Element] Toc elements hierarchy
    def toc
      Kramdown::Converter::Toc.convert(document.root).first
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
          Kramdown::Converter::Html.send(:new, document, { :auto_id_prefix => '' }).generate_id(element.options[:raw_text])
        )
      end
    end

    # @return [String] content parsed to HTML by the markdown engine.
    def to_html
      @to_html ||= Typogruby.improve(@document.to_html)
    end

    # @return [String] Text of the first heading in this chapter
    def title
      @title ||= begin
        (heading = outline.first) ? heading.text : 'untitled'
      end
    end

    # @return [Array<String>] list of all image references
    def images
      @images ||= elements(:img).map { |e| e.attr['src'] }
    end

    private

    attr_reader :document

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
