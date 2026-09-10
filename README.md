# Realtor API Ruby client

Fetches the facts Realtor states about a home, reached through
[RapidAPI](https://rapidapi.com/apidojo/api/realty-in-us).

- Source: https://github.com/claudiob/alt
- API reference: https://rubydoc.info/gems/alt

## How to install

Install the gem system-wide:

```sh
gem install alt
```

Or add it to a Gemfile, pinned to the current major:

```ruby
gem 'alt', '~> 2.0'
```

`~> major.minor` means `bundle update` never crosses a breaking change.

## Authentication

Subscribe to the Realtor API on RapidAPI and set your key as an environment variable:

- `ENV['RAPIDAPI_KEY']`

The host (`realty-in-us.p.rapidapi.com`) is sent automatically as `X-RapidAPI-Host`.

## Available methods

```ruby
property = Alt::Property.new address: "4352 Desert Park Ave", unit: nil, city: "North Las Vegas", zipcode: "89085"

property.facts
# => { "Lot size" => 0.1837, "Living area" => 3000, "Bedrooms" => 5, "Bathrooms" => 2,
#      "Year built" => 1999, "Stories" => 2, "Garage spaces" => 3, "Fireplaces" => 2,
#      "Property type" => "Single family", "Heating system" => "Forced air",
#      "Heating fuel" => "Natural gas", "Cooling" => "Central air",
#      "Roof" => "Asphalt shingle", "Construction" => "Brick", "Sewer" => "Public",
#      "Foundation" => "Slab", "Pool" => "Yes", "Outdoor living" => "Yes",
#      "Fence" => "Yes", "Sprinklers" => "Yes", "Coordinate" => [36.2814, -115.1543] }
```

Every key is named after the fact it states, so a host stores each under whatever it calls
it. A fact the listing does not state is **left out** rather than answered as a zero or a
`false`: the response cannot tell "no pool" from "no mention of a pool", and a value that
says the second while meaning the first is worse than no value at all.

`Coordinate` is the one entry not meant for storage. It answers `[lat, lon]` so that a host
can place the home on a map; a precise coordinate kept beside a street address is personal
data, so pin with it and drop it.

Nothing else Realtor sends comes back. The response also carries the street, an `href`
whose slug is the street address, the listing agent's name, email and phones, and a Street
View URL embedding both the address and a live Maps key — an allow-list rather than a
deny-list is what keeps all of it out.

## How a fact is read

Realtor answers two blocks worth reading: `description`, which states the home's own
figures and its kind, and `details`, an array of `{ category, text[] }` where each `text`
entry is a `"Label: value"` sentence written in whichever dialect the listing MLS uses.

One fact is spelled many ways, and a comma-joined value carries two facts at once. So each
choice is mapped onto a closed set of options — `Warm Air`, `Forced Air` and `ForcedAir`
are all `Forced air`; `Forced Air, Natural Gas` answers a heating system *and* a heating
fuel — and anything the mapping does not name answers `Other`. The options were derived
from 329 real enrichments rather than from the API's documentation, which does not describe
these fields.

## How a lookup works

Realtor has no address-to-detail endpoint, so a lookup takes two requests:

1. `GET /locations/v2/auto-complete?input=<address>` — resolves the address to a property id
2. `GET /properties/v3/detail?property_id=<id>` — returns the details

`Alt::Error` is raised when either request fails, or when the address matches no property.
