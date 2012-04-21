module Rpub
  class Epub
    class HtmlToc < XmlFile
      attr_reader :book

      def initialize(book)
        @book = book
        super()
      end

      def render
        xml.div :id => 'toc' do
          xml.h1 'Table of Contents'
          xml.div :class => 'toc' do
            book.outline.each do |(filename, heading)|
              xml.div :class => "level-#{heading.level}" do
                xml.a heading.text, :href => [filename, heading.html_id].join('#')
              end
            end
          end
        end
      end
    end
  end
end
