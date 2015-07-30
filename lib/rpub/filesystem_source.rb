require 'open-uri'
module Rpub
  module FilesystemSource
    module_function

    def read(filename)
      open(filename) { |f| f.read }
    end

    def exists?(filename)
      File.exists?(filename)
    end

    def source_files
      Dir['*{.md,.markdown,.mdown,.markd}']
    end

    def write(filename, content, force = false)
      return if content.nil?
      if !force && File.exist?(filename)
        warn "Not overriding #{filename}"
        return
      end
      File.open(filename, 'w') do |f|
        f.write content
      end
    end

    def force_write(filename, content)
      write filename, content, true
    end

    def remove(filename, dry_run = false)
      if File.exist?(filename)
        if dry_run
          puts filename
        else
          File.unlink(filename)
        end
      end
    end

    def own_or_support_file(filename)
      return filename if exists?(filename)
      Rpub.support_file(filename)
    end
  end
end
