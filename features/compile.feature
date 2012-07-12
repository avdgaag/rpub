Feature: Compilation
    As an author
    I want to compile my contents into an epub file
    So my audience can read it on his e-reader device

    Background:
        Given a file named "chapter1.md" with:
        """
        # Hello, world

        lorem ipsum
        """

    Scenario: generate epub file
        Given the default "config.yml" file
        When I successfully run `rpub compile`
        Then a file named "untitled-book-0.0.0.epub" should exist

    Scenario: file versioning
        Given the default "config.yml" file with:
            | version | 1.2.3   |
            | title   | My book |
        When I successfully run `rpub compile`
        Then a file named "my-book-1.2.3.epub" should exist

    @epubcheck
    Scenario: valid epub file
        Given the default "config.yml" file
        When I successfully run `rpub compile`
        And I run `epubcheck untitled-book-0.0.0.epub`
        Then the output should contain "No errors or warnings detected"

    Scenario: help
        When I successfully run `rpub compile -h`
        Then the stdout should contain "Compile your Markdown-formatted input files"

    Scenario: overriding configuration
        Given the default "config.yml" file
        When I successfully run `mv config.yml settings.yml`
        And I successfully run `rpub compile -c settings.yml`
        Then a file named "untitled-book-0.0.0.epub" should exist
