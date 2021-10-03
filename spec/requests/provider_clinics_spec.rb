# frozen_string_literal: true

require 'rails_helper'

# Given more time would turn off the ability to make 3rd party API requests
# and would use VCR or stub the API calls

RSpec.describe 'provider clinics', type: :request do
  let(:json_response) { JSON.parse response.body }
  let(:clinics) { json_response['data'] }

  let!(:closest_tier_a_clinic) { create(:provider_clinic, tier: 'A', zipcode: '14543') }
  let!(:closest_tier_b_clinic) { create(:provider_clinic, tier: 'B', zipcode: '14467') }
  let!(:farthest_tier_b_clinic) { create(:provider_clinic, tier: 'B', zipcode: '14546') }
  let(:closest_overall_clinic) { closest_tier_b_clinic }
  let(:farthest_overall_clinic) { closest_tier_a_clinic }

  it 'requires a zipcode' do
    get '/provider_clinics.json'
    expect(response.status).to eq(422)
  end

  it 'returns clinics within 20 miles of a given zipcode' do
    get '/provider_clinics.json', params: { zipcode: '14586' }
    expect(clinics.length).to eq(3)
    expect(response.status).to eq(200)
  end

  it 'does not return a lower tier clinic first, even if its closest' do
    get '/provider_clinics.json', params: { zipcode: '14586' }

    expect(clinics.first['id']).not_to eq(closest_overall_clinic.id.to_s)
  end

  it 'does not return a higher tier clinic last, even if its farthest' do
    get '/provider_clinics.json', params: { zipcode: '14586' }

    expect(clinics.last['id']).not_to eq(farthest_overall_clinic.id.to_s)
  end

  it 'returns the closest tier A clinic first' do
    get '/provider_clinics.json', params: { zipcode: '14586' }

    expect(clinics.first['id']).to eq(closest_tier_a_clinic.id.to_s)
  end

  it 'returns the closest tier B clinic next' do
    get '/provider_clinics.json', params: { zipcode: '14586' }

    expect(clinics.second['id']).to eq(closest_tier_b_clinic.id.to_s)
  end

  it 'returns the farther and lowst tier clinic last' do
    get '/provider_clinics.json', params: { zipcode: '14586' }

    expect(clinics.last['id']).to eq(farthest_tier_b_clinic.id.to_s)
  end
end
