# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProviderClinic', type: :model do
  describe '.by_tier_and_distance' do
    let!(:closest_tier_a_clinic) { create(:provider_clinic, tier: 'A', zipcode: '14543') }
    let!(:closest_tier_b_clinic) { create(:provider_clinic, tier: 'B', zipcode: '14467') }
    let!(:farthest_tier_b_clinic) { create(:provider_clinic, tier: 'B', zipcode: '14546') }
    let(:closest_overall_clinic) { closest_tier_b_clinic }
    let(:farthest_overall_clinic) { closest_tier_a_clinic }
    let(:zipcodes_by_distance) do
      { '14543': 5.036, '14467': 3.923, '14546': 4.614 }
    end

    it 'does not return a lower tier clinic first, even if its closest' do
      result = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)

      expect(result.first.id).not_to eq(closest_overall_clinic.id)
    end

    it 'does not return a higher tier clinic last, even if its farthest' do
      result = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)

      expect(result.last.id).not_to eq(farthest_overall_clinic.id)
    end

    it 'returns the closest tier A clinic first' do
      result = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)

      expect(result.first.id).to eq(closest_tier_a_clinic.id)
    end

    it 'returns the closest tier B clinic next' do
      result = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)

      expect(result.second.id).to eq(closest_tier_b_clinic.id)
    end

    it 'returns the farthest and lowest tier clinic last' do
      result = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)

      expect(result.third.id).to eq(farthest_tier_b_clinic.id)
    end

    it 'returns an error if no zipcodes by distance are given' do
      expect { ProviderClinic.by_tier_and_distance }.to raise_error(
        'Please provide a hash of zipcodes and their distances from a location'
      )
    end
  end

  describe '.upper_tiers' do
    let!(:a_tier_clinic) { create(:provider_clinic, tier: 'A', zipcode: '14543') }
    let!(:b_tier_clinic) { create(:provider_clinic, tier: 'B', zipcode: '14586') }
    let!(:c_tier_clinic) { create(:provider_clinic, tier: 'C', zipcode: '14907') }
    let!(:lower_tier_clinic) { create(:provider_clinic, tier: 'D', zipcode: '14543') }

    it 'returns clinics in tier A' do
      result = ProviderClinic.upper_tiers
      expect(result).to include(a_tier_clinic)
    end

    it 'returns clinics in tier B' do
      result = ProviderClinic.upper_tiers
      expect(result).to include(b_tier_clinic)
    end

    it 'returns clinics in tier C' do
      result = ProviderClinic.upper_tiers
      expect(result).to include(c_tier_clinic)
    end

    it 'does not return clinics in lower tiers' do
      result = ProviderClinic.upper_tiers
      expect(result).not_to include(lower_tier_clinic)
    end
  end

  describe '.in_zipcodes' do
    let!(:clinic_in_zip) { create(:provider_clinic, zipcode: '14586', tier: 'B') }
    let!(:other_clinic_in_zip) { create(:provider_clinic, zipcode: '14586', tier: 'A') }
    let!(:clinic_in_other_zip) { create(:provider_clinic, zipcode: '03176', tier: 'B') }

    it 'returns clinics in the given zipcodes' do
      result = ProviderClinic.in_zipcodes(['14586'])
      expect(result).to include(clinic_in_zip, other_clinic_in_zip)
    end

    it 'does not return clinics not in the given zipcode' do
      result = ProviderClinic.in_zipcodes(['14586'])
      expect(result).not_to include(clinic_in_other_zip)
    end

    it 'returns clinics from multiple zipcodes' do
      result = ProviderClinic.in_zipcodes(%w[14586 03176])
      expect(result).to include(clinic_in_zip, other_clinic_in_zip, clinic_in_other_zip)
    end
  end
end
