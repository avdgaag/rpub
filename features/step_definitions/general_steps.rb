def read_support_file(filename)
  File.read(File.join(SUPPORT_PATH, filename))
end

Given /^the default "(.*?)" file$/ do |filename|
  write_file filename, read_support_file(filename)
end

Given /^the default "config.yml" file with "(.*?)" set to "(.*?)"$/ do |key, value|
  config = YAML.load(read_support_file('config.yml'))
  value = false if value == 'false'
  value = value.to_i if value =~ /^\d+$/
  config[key] = value
  write_file 'config.yml', YAML.dump(config)
end

Given /^the default "config.yml" file with:$/ do |settings|
  config = YAML.load(read_support_file('config.yml'))
  config.merge! settings.rows_hash
  write_file 'config.yml', YAML.dump(config)
end

Then /^the default file "(.*?)" should exist$/ do |filename|
  step %Q{a file named "#{filename}" should exist}
  step %Q{the file "#{filename}" should contain exactly:}, read_support_file(filename)
end

Then /^the archive "(.*?)" should contain file "(.*?)"$/ do |filename, entry|
  in_current_dir do
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      zipfile.get_entry(entry)
    end
  end
end

Then /^the archive "(.*?)" should not contain file "(.*?)"$/ do |filename, entry|
  in_current_dir do
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      expect(zipfile.find_entry(entry)).to be_nil
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
        # Chapter 1

        Hello, world
        """
  }
end
