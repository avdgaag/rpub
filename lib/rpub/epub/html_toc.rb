module Rpub
  class Epub
    class HtmlToc < XmlFile
      def render
        xml.div :id => 'toc' do
          xml.h1 'Table of Contents'
          xml.div :class => 'toc' do
            book.outline.each do |(filename, headings)|
              headings.each do |heading|
                if heading.level <= (book.config.max_level || 2)
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
  end
end
