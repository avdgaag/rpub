Feature: embedding assets
    As an author
    I want to include custom fonts and images
    In order to spice up the look of my book

    Background:
        Given a file named "chapter2.md" with:
        """
        # Chapter 2

        Here comes an image:

        ![alt text](image.jpg)

        ## Subheading

        Lorem ipsum
        """
        And an empty file named "image.jpg"

    Scenario: ignoring files
        When I successfully run `rpub compile`
        Then the archive "untitled-book-0.0.0.epub" should not contain file "OEBPS/README.md"

    Scenario: embedding fonts
        Given a file named "styles.css" with:
        """
        @font-face {
            font-family: Foo;
            src: url('Foo.otf');
        }
        p {
            font-family: Foo;
        }
        """
        And an empty file named "Foo.otf"
        When I successfully run `rpub compile`
        Then the archive "untitled-book-0.0.0.epub" should contain file "OEBPS/Foo.otf"

    Scenario: embedding images
        When I successfully run `rpub compile`
        Then the archive "untitled-book-0.0.0.epub" should contain file "OEBPS/image.jpg"
