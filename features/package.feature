Feature: packaging
    As an author
    I want to package my book and other files into a single archive
    So I can easily distribute it over the internet

    Background:
        Given a basic project

    Scenario: compressing book
        When I successfully run `rpub package`
        Then a file named "untitled_book.zip" should exist
        And the archive "untitled_book.zip" should contain file "untitled-book-0.0.0.epub"

    Scenario: custom package filename
        Given the default "config.yml" file with "package_file" set to "my_book.zip"
        When I successfully run `rpub package`
        Then a file named "my_book.zip" should exist

    Scenario: uncompiled book
        When I successfully run `rpub package`
        Then a file named "untitled-book-0.0.0.epub" should exist

    Scenario: help
        When I successfully run `rpub package -h`
        Then the output should contain "Compile your ebook to an ePub file and package it into an archive"

    Scenario: additional files
        When I successfully run `rpub package`
        Then a file named "untitled_book.zip" should exist
        And the archive "untitled_book.zip" should contain file "README.md"
