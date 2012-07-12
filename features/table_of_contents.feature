Feature: automatic table of contents
    As an author
    I want to have my table of contents automatically generated
    So I don't have to do it manually

    Background:
        Given a file named "chapter1.md" with:
        """
        # Chapter 1

        ## Subheading

        Lorem ipsum
        """

    Scenario: skipping human-readable table of contents
        When I successfully run `rpub compile`
        And I run `unzip untitled-book-0.0.0.epub`
        Then a file named "OEBPS/toc.html" should exist
        And the file "OEBPS/toc.html" should contain "Chapter 1"
        And the file "OEBPS/toc.html" should contain "Subheading"

    Scenario: human-readable table of contents
        Given the default "config.yml" file with "toc" set to "false"
        When I successfully run `rpub compile`
        And I run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/toc.html" should not exist

    Scenario: custom table of contents depth
        Given the default "config.yml" file with "max_level" set to "1"
        When I successfully run `rpub compile`
        And I run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/toc.html" should contain "Chapter 1"
        And the file "OEBPS/toc.html" should not contain "Subheading"

