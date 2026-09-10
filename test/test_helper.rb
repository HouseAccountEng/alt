# frozen_string_literal: true

require 'alt'
require 'json'
require 'minitest/autorun'
require 'webmock/minitest'

# What every test of this gem shares: the two requests a lookup makes, answered locally.
module Answered
  # The address the stubs below answer for, which is any address a test asks about.
  ADDRESS = { address: '1 Rodeo Drive', city: 'Beverly Hills', zipcode: '90210' }.freeze

  # The facts Realtor states about a home whose `description` and `details` a test names.
  def facts_for(description: {}, details: [], location: {})
    home = { description: description, location: location,
             details: [{ category: 'Test', text: details }] }
    stub_realtor 'locations/v2/auto-complete', autocomplete: [{ mpr_id: '1' }]
    stub_realtor 'properties/v3/detail', data: { home: home }

    Alt::Property.new(ADDRESS).facts
  end

private

  def stub_realtor(path, body)
    stub_request(:get, %r{\Ahttps://#{Alt::Property::HOST}/#{path}}).
      to_return status: 200, body: JSON.generate(body)
  end
end
