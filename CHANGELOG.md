## [0.0.3] - 2026-08-04

- Implement `Alt::Property#property_details`, which was previously a `# TODO` returning `nil`.
  A lookup now issues two requests against RapidAPI's `realty-in-us` host: an
  `/locations/v2/auto-complete` call to resolve the address to a property id, then a
  `/properties/v3/detail` call for the details.
- Authenticate with `ENV['RAPIDAPI_KEY']` via the `X-RapidAPI-Key` header.
- Raise `Alt::Error` on any non-2xx response, and when the address matches no property.
- `property_details` now returns the whole parsed response body. It previously read a
  `property_details` key that the Realtor API does not send.
- Fix documentation copied from the HouseCanary client: the README described HouseCanary
  authentication and its `subject_address`/`public_records`/`assessment` methods, none of which
  exist on `Alt::Property`, and `Alt::Error` was documented as a HouseCanary error.

## [0.0.2] - 2026-07-28

- Initial release
