require 'rpub'

FIXTURES_DIRECTORY = File.expand_path('../fixtures', __FILE__)

RSpec::Matchers.define :remove_file do |filename|
  match do |block|
    before = File.exist?(filename)
    block.call
    after = File.exist?(filename)
    before && !after
  end
end

RSpec::Matchers.define :create_file do |filename|
  match do |block|
    before = File.exist?(filename)
    block.call
    after = File.exist?(filename)
    !before && after
  end
end
