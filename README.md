This was an individual project in Module 3 at Turing School of Software & Design. The project description can be found here: [Project Outline](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/rails_engine.md)

I used Rails and ActiveRecord to build a JSON API which exposes the SalesEngine data schema. Sales Engine was a project completed in Module 1.

## Learning Goals

* Learn how to to build Single-Responsibility controllers to provide a well-designed and versioned API.
* Learn how to use controller tests to drive your design.
* Use Ruby and ActiveRecord to perform more complicated business intelligence.

## Technical Expectations

* All endpoints will expect to return JSON data
* All endpoints should be exposed under an api and version (v1) namespace (e.g. /api/v1/merchants.json)
* JSON responses should included ids only for associated records unless otherwise indicated (that is, don't embed the whole associated record, just the id)
* Prices are in cents, therefore you will need to transform them in dollars. (12345 becomes 123.45)
* Remember that for a JSON string to be valid, it needs to contain a key and a value.
