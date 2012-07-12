Feature: Generate boilerplate files
    As an author
    I want to generate boilerplate files
    So I can get writing quickly

    Scenario: Help
        When I successfully run `rpub generate -h`
        Then the stdout should contain "Generate one or more standard files"

    Scenario: Generate all
        When I successfully run `rpub generate`
        Then the default file "config.yml" should exist
        And the default file "layout.html" should exist
        And the default file "styles.css" should exist

    Scenario: All but styles
        When I successfully run `rpub generate --no-styles`
        Then the default file "config.yml" should exist
        And the default file "layout.html" should exist
        And a file named "styles.css" should not exist

    Scenario: All but layout
        When I successfully run `rpub generate --no-layout`
        Then the default file "config.yml" should exist
        And a file named "layout.html" should not exist
        And the default file "styles.css" should exist

    Scenario: All but configuration
        When I successfully run `rpub generate --no-config`
        Then a file named "config.yml" should not exist
        And the default file "layout.html" should exist
        And the default file "styles.css" should exist

    Scenario: Only styles
        When I successfully run `rpub generate --styles`
        Then a file named "config.yml" should not exist
        And a file named "layout.html" should not exist
        And the default file "styles.css" should exist

    Scenario: Only layout
        When I successfully run `rpub generate --layout`
        Then a file named "config.yml" should not exist
        And the default file "layout.html" should exist
        And a file named "styles.css" should not exist

    Scenario: Only configuration
        When I successfully run `rpub generate --config`
        Then the default file "config.yml" should exist
        And a file named "layout.html" should not exist
        And a file named "styles.css" should not exist

    Scenario: Not overriding existing files
        Given a file named "layout.html" with:
            """
            Foo
            """
        When I successfully run `rpub generate --layout`
        Then the stderr should contain "Not overriding layout.html"
        And the file "layout.html" should contain exactly:
            """
            Foo
            """

