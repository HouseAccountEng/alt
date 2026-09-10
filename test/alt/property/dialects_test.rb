# frozen_string_literal: true

require 'test_helper'

# The MLS spells one fact many ways, and a mapping is only as good as the spellings it
# recognizes, so every branch of every mapping is walked here against a line Realtor sent.
class Alt::Property::DialectsTest < Minitest::Test
  include Answered

  DIALECTS = [
    ['Roof: Asphalt Shingle', 'Roof', 'Asphalt shingle'],
    ['Roof: Concrete Tile', 'Roof', 'Tile'],
    ['Roof: Slate/Slag', 'Roof', 'Slate'],
    ['Roof: Corrugated Metal', 'Roof', 'Metal'],
    ['Roof: Wood', 'Roof', 'Wood'],
    ['Roof: Membrane', 'Roof', 'Other'],
    ['Construction Materials: Brick', 'Construction', 'Brick'],
    ['Construction Materials: Vinyl Siding', 'Construction', 'Vinyl'],
    ['Building Exterior Type: Cedar', 'Construction', 'Wood'],
    ['Exterior: Aluminum Siding', 'Construction', 'Aluminum'],
    ['Construction Materials: Stone, Stucco', 'Construction', 'Masonry'],
    ['Construction Materials: Shingles', 'Construction', 'Other'],
    ['Foundation Details: Slab', 'Foundation', 'Slab'],
    ['Foundation Details: Crawl Space', 'Foundation', 'Crawl space'],
    ['Foundation Details: Block', 'Foundation', 'Block'],
    ['Foundation Details: Concrete Perimeter', 'Foundation', 'Concrete'],
    ['Foundation Details: Brick/Mortar', 'Foundation', 'Stone'],
    ['Foundation Details: PillarPostPier', 'Foundation', 'Other'],
    ['Sewer: Public Sewer', 'Sewer', 'Public'],
    ['Septic Tank', 'Sewer', 'Septic'],
    ['Sewer: Private Sewer', 'Sewer', 'Private'],
    ['Sewer: STEP System', 'Sewer', 'Other'],
    ['Cooling Features: Central Air', 'Cooling', 'Central air'],
    ['Cooling Features: Heat Pump', 'Cooling', 'Heat pump'],
    ['Cooling: Air Conditioning-Room', 'Cooling', 'Wall or window'],
    ['Cooling: Evaporative', 'Cooling', 'Evaporative'],
    ['Cooling Features: Ceiling Fan(s)', 'Cooling', 'Ceiling fan'],
    ['Cooling: Type Unknown', 'Cooling', 'Other'],
    ['Heating Features: Forced Air, Natural Gas', 'Heating system', 'Forced air'],
    ['Heating Features: Forced Air, Natural Gas', 'Heating fuel', 'Natural gas'],
    ['Heating: Heat Pump, Electric', 'Heating system', 'Heat pump'],
    ['Heating: Heat Pump, Electric', 'Heating fuel', 'Electric'],
    ['Heating Features: Oil Hot Water', 'Heating system', 'Hot water'],
    ['Heating Features: Oil Hot Water', 'Heating fuel', 'Oil'],
    ['Heating: Baseboard, Propane', 'Heating system', 'Baseboard'],
    ['Heating: Baseboard, Propane', 'Heating fuel', 'Propane'],
    ['Heating: Central', 'Heating system', 'Central'],
    ['Heating: Type Unknown', 'Heating system', 'Other'],
    ['Number of Fireplaces: 2', 'Fireplaces', 2],
    ['Pool Private: Yes', 'Pool', 'Yes'],
    ['Patio And Porch Features: Covered, Deck', 'Outdoor living', 'Yes'],
    ['Fencing: Wood', 'Fence', 'Yes'],
    ['Sprinkler System', 'Sprinklers', 'Yes'],
  ].freeze

  def test_a_fact_stated_in_any_dialect_is_named_by_the_option_it_stands_for
    DIALECTS.each do |line, fact, option|
      assert_equal option, facts_for(details: [line])[fact], line
    end
  end

  def test_a_line_describing_a_fact_rather_than_stating_it_answers_nothing
    facts = facts_for details: ['Fireplace features: Gas']

    assert_equal ['Coordinate'], facts.keys
  end
end
