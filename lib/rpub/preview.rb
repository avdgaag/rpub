module Rpub
  class Preview
    attr_reader :context, :source

    def initialize(context, source)
      @context, @source = context, source
    end

    def formatted
      return unless context.chapter_files.any?
      move_styles_inline(plain)
    end

    def text
      Nokogiri::HTML(plain).xpath('//text()').to_s
    end

    private

    def plain
      Rpub.document_factory.call(context.chapter_files.join("\n"), context.layout).to_html
    end

    def move_styles_inline(html)
      style_block = %Q{<style>\n#{source.read(context.styles)}\n</style>}
      html.gsub %r{</head>}, style_block + "\n</head>"
    end
  end
end
