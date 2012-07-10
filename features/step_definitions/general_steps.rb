# This step is not yet in the released version of Aruba, only in unreleased master branch
Then /^the file "([^"]*)" should contain:$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

def read_support_file(filename)
  File.read(File.join(SUPPORT_PATH, filename))
end

Given /^the default "(.*?)" file$/ do |filename|
  write_file filename, read_support_file(filename)
end

Then /^the default file "(.*?)" should exist$/ do |filename|
  step %Q{a file named "#{filename}" should exist}
  step %Q{the file "#{filename}" should contain exactly:}, read_support_file(filename)
end
