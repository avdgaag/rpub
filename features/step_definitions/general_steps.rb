# This step is not yet in the released version of Aruba, only in unreleased master branch
Then /^the file "([^"]*)" should contain:$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

Given /^the default "(.*?)" file$/ do |filename|
  write_file filename, File.read(File.join(SUPPORT_PATH, filename))
end
