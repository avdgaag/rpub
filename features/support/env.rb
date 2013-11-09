require 'aruba/cucumber'
require 'zip'
SUPPORT_PATH = File.expand_path(File.join(*%w[.. .. .. support]), __FILE__)

Before do
  @aruba_timeout_seconds = 5
end
