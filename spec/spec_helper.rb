if RUBY_VERSION >= '1.9' && ENV.has_key?('COVERAGE')
  require 'simplecov'
  SimpleCov.start
end

if ENV.has_key?('TRAVIS')
  require 'coveralls'
  Coveralls.wear!
end

require 'rpub'
require 'nokogiri'

FIXTURES_DIRECTORY = File.expand_path('../fixtures', __FILE__)

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.profile_examples = 10
  end

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

RSpec::Matchers.define :remove_file do |filename|
  match do |block|
    before = File.exist?(filename)
    block.call
    after = File.exist?(filename)
    before && !after
  end
end

RSpec::Matchers.define :create_file do |*filenames|
  match do |block|
    before = filenames.all?(&File.method(:exist?))
    block.call
    after = filenames.all?(&File.method(:exist?))
    !before && after
  end
end

RSpec::Matchers.define :have_xpath do |xpath, *args|
  match do |xml|
    Nokogiri::XML(xml).xpath(xpath, *args).any?
  end
end
