# Realtor API Ruby client

Fetches property details from Realtor, reached through
[RapidAPI](https://rapidapi.com/apidojo/api/realty-in-us).

## Authentication

Subscribe to the Realtor API on RapidAPI and set your key as an environment variable:

- `ENV['RAPIDAPI_KEY']`

The host (`realty-in-us.p.rapidapi.com`) is sent automatically as `X-RapidAPI-Host`.

## Available methods

```ruby
property = Alt::Property.new address: "4352 Desert Park Ave", unit: nil, city: "North Las Vegas", zipcode: "89085"

property.property_details # => the parsed `/properties/v3/detail` response body
```

Unlike HouseCanary, which returns separate `subject_address`, `public_records` and
`assessment` objects, Realtor returns a single object, exposed here as `property_details`.

## How a lookup works

Realtor has no address-to-detail endpoint, so a lookup takes two requests:

1. `GET /locations/v2/auto-complete?input=<address>` — resolves the address to a property id
2. `GET /properties/v3/detail?property_id=<id>` — returns the details

`Alt::Error` is raised when either request fails, or when the address matches no property.

## Status

The two endpoint paths above are confirmed to exist. The following identifiers are **not yet
verified against a live response** (the account's RapidAPI quota was exhausted at the time of
writing) and should be checked against the RapidAPI playground before relying on this client:

- the `input` query parameter name for `/locations/v2/auto-complete`
- the `autocomplete` array and its `mpr_id` field in that response
- the `property_id` query parameter name for `/properties/v3/detail`
