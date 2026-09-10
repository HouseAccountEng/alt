## [Unreleased]

## [2.0.0] - 2026-09-10

- [Breaking change] `Alt::Property#property_details` is gone, and `#facts` answers in its
  place. Where the old method handed back Realtor's whole 73-key document, the new one
  answers only the facts worth keeping, each named by what it is: `Bedrooms`, `Lot size`
  (in acres), `Living area`, `Bathrooms`, `Year built`, `Stories`, `Garage spaces`,
  `Fireplaces`, `Property type`, `Heating system`, `Heating fuel`, `Cooling`, `Roof`,
  `Construction`, `Sewer`, `Foundation`, `Pool`, `Outdoor living`, `Fence` and
  `Sprinklers`. A fact the listing does not state is left out rather than answered as a
  zero or a `false`, since the response cannot tell "no pool" from "no mention of a pool".
- [Feature] The MLS dialect a listing is written in is mapped onto a closed set of options.
  One fact is spelled many ways — `Warm Air`, `Forced Air` and `ForcedAir` are one heating
  system, `Asphalt Shingle`, `Composition` and `Architectural Shingles` are one roof — and
  a comma-joined value carries two facts at once, so `Forced Air, Natural Gas` answers a
  heating system and a heating fuel separately. Every option was derived from 329 real
  enrichments, and everything the mapping does not name answers `Other`.
- [Feature] `Coordinate` answers the point Realtor places the home at, as `[lat, lon]`. It
  is the one entry not meant for storage: a host pins the place with it and drops it, since
  a precise coordinate kept beside a street is personal data.
- [Fix] An acre is 43,560 square feet, not 43,561. `Lot size` was previously computed by
  whoever called this gem, using the second number.

## [1.0.1] - 2026-08-24

- [Fix] Raise Error when autocomplete doesn't return a valid address.

## [1.0.0] - 2026-08-05

- Implement `Alt::Property#property_details`, which was previously a `# TODO` returning `nil`.
  A lookup now issues two requests against RapidAPI's `realty-in-us` host: an
  `/locations/v2/auto-complete` call to resolve the address to a property id, then a
  `/properties/v3/detail` call for the details.

## [0.0.2] - 2026-07-28

- Initial release
