module RPub
  class Epub
    class Container < XmlFile
      def render
        xml.instruct!
        xml.container version: '1.0', xmlns: 'urn:oasis:names:tc:opendocument:xmlns:container' do
          xml.rootfiles do
            xml.rootfile 'full-path' => 'OEBPS/content.opf', 'media-type' => 'application/oebps-package+xml'
          end
        end
      end
    end
  end
end
