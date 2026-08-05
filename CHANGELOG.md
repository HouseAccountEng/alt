## [1.0.0] - 2026-08-05

- Implement `Alt::Property#property_details`, which was previously a `# TODO` returning `nil`.
  A lookup now issues two requests against RapidAPI's `realty-in-us` host: an
  `/locations/v2/auto-complete` call to resolve the address to a property id, then a
  `/properties/v3/detail` call for the details.

## [0.0.2] - 2026-07-28

- Initial release
