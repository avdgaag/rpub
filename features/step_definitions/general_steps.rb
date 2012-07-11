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

Given /^the default "(.*?)" file with "(.*?)" set to "(.*?)"$/ do |filename, key, value|
  config = YAML.load(read_support_file(filename))
  config[key] = value
  write_file filename, YAML.dump(config)
end

Then /^the default file "(.*?)" should exist$/ do |filename|
  step %Q{a file named "#{filename}" should exist}
  step %Q{the file "#{filename}" should contain exactly:}, read_support_file(filename)
end

Then /^the archive "(.*?)" should contain file "(.*?)"$/ do |filename, entry|
  in_current_dir do
    Zip::ZipFile.open(filename, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.get_entry(entry)
    end
  end
end

Given /^a basic project$/ do
  steps %Q{
    Given a file named "README.md" with:
        """
        README file
        """
    And the default "layout.html" file
    And the default "styles.css" file
    And the default "config.yml" file
    And a file named "chapter1.md" with:
        """
        Hello, world
        """
  }
end
