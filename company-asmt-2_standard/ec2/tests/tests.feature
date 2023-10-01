Feature: My test feature

Scenario: AWS Credentials should not be hardcoded
  Given I have aws provider configured
  When it contains access_key
  Then its value must not match the "*" regex

Scenario: Ensure a multi-layered network architecture
  Given I have AWS Subnet defined
  When I count them
  Then I expect the result is more than 1