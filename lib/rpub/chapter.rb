module Rpub
  # Representation of a chapter in the book, from a single input file from the
  # project directory.  The Chapter object knows how to turn itself into HTML
  # suitable for writing to the epub archive with the appropriate identifiers
  # to be listed in the epub manifest files.
  class Chapter
    extend Forwardable
    def_delegators :@document, :images, :outline, :toc, :title, :to_html

    # @return [String] raw textual contents of this chapter
    attr_reader :content

    # @return [Fixnum] chapter number provided by its associated Book object
    attr_reader :number

    # @return [String] filename of the layout to use, to be passed directly to the Kramdown gem.
    attr_reader :layout

    def initialize(content, number, layout)
      @content, @number, @layout = content, number, layout
      @document = Document.new(content, layout)
    end

    # @return [String] Unique identifier for this chapter.
    def uid
      @uid ||= Digest::SHA1.hexdigest([content, xml_id.to_s, layout].join)
    end

    # @return [String] XML-friendly slug for this chapter based on its number.
    def xml_id
      @id ||= "chapter-#{number}"
    end

    # @return [String] name for the file in the zip to use, based on the title
    def filename
      @filename ||= xml_id.to_s + '-' + title.gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.html'
    end
  end
end
