Feature: clean the working tree
    As an author
    I want to remove generated files
    In order to return my working tree to a pristine state

    Background:
        Given a basic project

    Scenario: preview file
        Given an empty file named "preview.html"
        When I successfully run `rpub clean`
        Then the file "preview.html" should not exist

    Scenario: book
        Given an empty file named "untitled-book-0.0.0.epub"
        When I successfully run `rpub clean`
        Then the file "untitled-book-0.0.0.epub" should not exist

    Scenario: dry run mode
        Given an empty file named "preview.html"
        And an empty file named "untitled-book-0.0.0.epub"
        When I successfully run `rpub clean -d`
        Then the output should contain "preview.html"
        And the output should contain "untitled-book-0.0.0.epub"
        And a file named "preview.html" should exist
        And a file named "untitled-book-0.0.0.epub" should exist

    Scenario: help
        When I successfully run `rpub clean -h`
        Then the output should contain "Clean up all generated files"

