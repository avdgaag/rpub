module Rpub
  # Wrapper around a +ZipOutputStream+ object provided by the +rubyzip+ gem.
  # This writes string contents straight into a zip file, without first saving
  # them to disk.
  class Compressor

    # @return [ZipOutputStream]
    attr_reader :zip

    # Convenience method for opening a stream, allowing content to be written
    # and finally closing the stream again.
    def self.open(filename)
      compressor = new(filename)
      yield compressor
      compressor.close
    end

    # @param [String] filename of the archive to write to disk
    def initialize(filename)
      @zip = Zip::OutputStream.new(filename)
    end

    # Close the zip stream and write the file to disk.
    def close
      zip.close
    end

    # Store a file in the archive without any compression.
    #
    # @param [String] filename under the which the data should be stored
    # @param [#to_s] content to be compressed
    def store_file(filename, content)
      zip.put_next_entry filename, nil, nil, Zip::Entry::STORED, Zlib::NO_COMPRESSION
      zip.write content.to_s
    end

    # Store a file with maximum compression in the archive.
    #
    # @param [String] filename under the which the data should be stored
    # @param [#to_s] content to be compressed
    def compress_file(filename, content)
      zip.put_next_entry filename, nil, nil, Zip::Entry::DEFLATED, Zlib::BEST_COMPRESSION
      zip.write content.to_s
    end
  end
end
