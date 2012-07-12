Feature: previews
    As an author
    I want to quickly see my words in an HTML file with the final formatting
    So I can see how my work will look without having to use a special e-reader

    Scenario: when there is no content
        Given the default "config.yml" file
        When I successfully run `rpub preview`
        Then a file named "preview.html" should not exist

    Scenario: concatenating content and styles
        Given the default "config.yml" file
        And a file named "chapter1.md" with:
            """
            Content 1
            """
        And a file named "chapter2.md" with:
            """
            Content 2
            """
        When I successfully run `rpub preview`
        Then a file named "preview.html" should exist
        And the file "preview.html" should contain:
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
            """
        And the file "preview.html" should contain "Content&nbsp;1"
        And the file "preview.html" should contain "Content&nbsp;2"
        And the file "preview.html" should contain:
            """
            body {
                margin: 3%;
                font-family: Georgia, serif;
                line-height: 1.4em;
            }
            """

    Scenario: given an explicit filename
        Given the default "config.yml" file
        And a file named "chapter1.md" with:
            """
            Content 1
            """
        When I successfully run `rpub preview -o output.html`
        Then a file named "preview.html" should not exist
        And a file named "output.html" should exist

    Scenario: given an explicit layout
        Given the default "config.yml" file
        And a file named "chapter1.md" with:
            """
            Content 1
            """
        And a file named "layout.html" with:
            """
            Custom layout
            <%= @body %>
            """
        When I successfully run `rpub preview -l layout.html`
        Then the file "preview.html" should contain "Custom&nbsp;layout"

    Scenario: getting help
        When I successfully run `rpub preview -h`
        Then the stdout should contain "Generate a single-page HTML file"
