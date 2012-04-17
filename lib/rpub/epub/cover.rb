module RPub
  class Epub
    class Cover < XmlFile
      attr_reader :book

      def initialize(book)
        @book = book
        super()
      end

      def render
        xml.declare! :DOCTYPE, :html, :PUBLIC, '-//W3C//DTD XHTML 1.0 Strict//EN', 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
        xml.html :xmlns => 'http://www.w3.org/1999/xhtml' do
          xml.head do
            xml.title 'Cover'
            xml.style 'img { max-width: 100%; }', :type => 'text/css'
          end
          xml.body do
            xml.div :id => 'cover-image' do
              xml.img :src => book.cover_image, :alt => book.title
            end
          end
        end
      end
    end
  end
end
