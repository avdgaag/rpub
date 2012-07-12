Feature: page layout
    As an author
    I want to wrap my content in a template file
    In order to spice up my book's looks

    Background:
        Given a file named "chapter1.md" with:
        """
        # Hello, world
        """

    Scenario: default layout
        When I successfully run `rpub compile`
        And I successfully run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/chapter-0-hello-world.html" should contain "<body>"

    Scenario: overriding layout by filename
        Given a file named "layout.html" with:
        """
        foo
        <%= @body %>
        bar
        """
        When I successfully run `rpub compile`
        And I successfully run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/chapter-0-hello-world.html" should contain "foo"
        And the file "OEBPS/chapter-0-hello-world.html" should contain "bar"

    Scenario: overriding layout by option
        Given a file named "template.html" with:
        """
        foo
        <%= @body %>
        bar
        """
        When I successfully run `rpub compile -l template.html`
        And I successfully run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/chapter-0-hello-world.html" should contain "foo"
        And the file "OEBPS/chapter-0-hello-world.html" should contain "bar"


