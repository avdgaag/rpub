module RPub
  class Compressor
    attr_reader :zip

    def self.open(filename)
      compressor = new(filename)
      yield compressor
      compressor.close
    end

    def initialize(filename)
      @zip = Zip::ZipOutputStream.new(filename)
    end

    def close
      zip.close
    end

    def store_file(filename, content)
      zip.put_next_entry filename, nil, nil, Zip::ZipEntry::STORED, Zlib::NO_COMPRESSION
      zip.write content.to_s
    end

    def compress_file(filename, content)
      zip.put_next_entry filename, nil, nil, Zip::ZipEntry::DEFLATED, Zlib::BEST_COMPRESSION
      zip.write content.to_s
    end
  end
end
