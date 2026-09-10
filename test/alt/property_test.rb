# frozen_string_literal: true

require 'test_helper'

# What a lookup answers about a home Realtor knows, fact by fact.
class Alt::PropertyTest < Minitest::Test
  include Answered

  # What Realtor's `description` block states about the home both tests below read.
  DESCRIPTION = { beds: 5, baths: 2, sqft: 3000, lot_sqft: 8000, year_built: 1999,
                  type: 'single_family', stories: 2, garage: 3 }.freeze

  def test_the_figures_a_description_states_are_answered_in_the_units_worth_storing
    facts = facts_for description: DESCRIPTION

    assert_in_delta 0.1837, facts['Lot size'], 0.0001
    assert_equal({ 'Living area' => 3000, 'Bedrooms' => 5, 'Bathrooms' => 2,
                   'Year built' => 1999, 'Stories' => 2, 'Garage spaces' => 3,
                   'Property type' => 'Single family' },
                 facts.slice('Living area', 'Bedrooms', 'Bathrooms', 'Year built', 'Stories',
                             'Garage spaces', 'Property type'))
  end

  def test_a_fact_nobody_stated_is_left_out_rather_than_answered_as_a_zero
    facts = facts_for

    assert_equal ['Coordinate'], facts.keys
  end

  def test_the_coordinate_is_answered_for_pinning_and_named_apart_from_the_facts
    coordinate = { address: { coordinate: { lat: 34.07, lon: -118.4 } } }

    assert_equal [34.07, -118.4], facts_for(location: coordinate)['Coordinate']
  end

  def test_an_address_matching_no_property_raises
    stub_request(:get, %r{auto-complete}).to_return status: 200, body: '{"autocomplete":[]}'

    assert_raises(Alt::Error) { Alt::Property.new(Answered::ADDRESS).facts }
  end
end
