module Rpub
  class Context
    def initialize(options = {})
      @config_file = options[:config]
      @layout      = options[:layout]
      @styles      = options[:styles]
    end

    def config
      @config ||= YAML.load_file(config_file) || {}
    end

    # @return [String] path to the current layout file (defaulting to built-in)
    def layout
      @layout ||= own_or_support_file('layout.html')
    end

    # @return [String] path to the current stylesheet file (defaulting to built-in)
    def styles
      @styles ||= own_or_support_file('styles.css')
    end

    def fonts
      @fonts ||= File.read(styles).scan(/url\((?:'|")?([^'")]+\.otf)(?:'|")?\)/i).flatten
    end

    # All chapter input files loaded into strings. This does not include any of
    # the files listed in the +ignore+ configuration key.
    #
    # @return [Array<String>]
    def chapter_files
      @chapter_files ||= filter_exceptions(Dir['*.md']).sort.map(&File.method(:read))
    end

    private

    def config_file
      @config_file ||= own_or_support_file('config.yml')
    end

    def own_or_support_file(filename)
      return filename if File.exists?(filename)
      Rpub.support_file(filename)
    end

    def filter_exceptions(filenames)
      return filenames unless config[:ignore]
      filenames.reject(&config[:ignore].method(:include?))
    end
  end
end
