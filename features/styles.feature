Feature: page layout
    As an author
    I want to format my text with CSS
    In order to spice up my book's looks

    Background:
        Given a file named "chapter1.md" with:
        """
        Hello, world
        """

    Scenario: default styles
        When I successfully run `rpub compile`
        Then the archive "untitled-book-0.0.0.epub" should contain file "OEBPS/styles.css"

    Scenario: overriding styles
        Given a file named "styles.css" with:
        """
        foo bar
        """
        When I successfully run `rpub compile`
        And I successfully run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/styles.css" should contain "foo bar"

    Scenario: custom styles
        Given a file named "formatting.css" with:
        """
        foo bar
        """
        When I successfully run `rpub compile -s formatting.css`
        And I successfully run `unzip untitled-book-0.0.0.epub`
        Then the file "OEBPS/styles.css" should contain "foo bar"

