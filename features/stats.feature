Feature: text statistics
    As an author
    I want to see some stats about my work
    In order to get a sense of progress

    Scenario: Lorem ipsum
        Given the default "config.yml" file
        And a file named "chapter1.md" with:
            """
            Lorem ipsum dolor sit amet"
            """
        When I successfully run `rpub stats`
        Then the output should contain "5 words"
        And the output should contain "1 pages"
        And the output should contain "1 sentences"
        And the output should contain "5.0 avg sentence length"
        And the output should contain "ari"
        And the output should contain "clf"
