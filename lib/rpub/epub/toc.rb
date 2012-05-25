module Rpub
  class Epub
    class Toc < XmlFile
      attr_reader :book

      def initialize(book)
        @book       = book
        @play_order = -1
        @max_level  = book.config.fetch(:max_level) { 2 }
        super()
      end

      def render
        xml.instruct!
        xml.declare! :DOCTYPE, :ncx, :PUBLIC, "-//W3C//DTD XHTML 1.1//EN", 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
        xml.ncx :xmlns => 'http://www.daisy.org/z3986/2005/ncx/', :version => '2005-1' do
          xml.head do
            xml.meta :name => 'dtb:uid',            :content => book.uid
            xml.meta :name => 'dtb:depth',          :content => '1'
            xml.meta :name => 'dtb:totalPageCount', :content => '0'
            xml.meta :name => 'dtb:maxPageNumber',  :content => '0'
          end
          xml.docTitle { xml.text book.title }
          xml.navMap do
            book.chapters.each do |chapter|
              nav_points_nested_by_level chapter
            end
          end
        end
      end

      private

      def next_play_order
        @play_order += 1
      end

      def nav_points_nested_by_level(chapter, level = 1, start = nil)
        chapter.outline.each_with_index do |heading, i|
          next if start && i < start
          break unless heading.level == level
          nav_point chapter.xml_id + '-' + heading.html_id, next_play_order, heading.text, chapter.filename + '#' + heading.html_id do
            if level < @max_level
              nav_points_nested_by_level chapter, level + 1, i + 1
            end
          end
        end
      end

      def nav_point(id, play_order, text, filename)
        xml.navPoint :id => id, :playOrder => play_order do
          xml.navLabel { xml.text text }
          xml.content :src => filename
          yield if block_given?
        end
      end
    end
  end
end

