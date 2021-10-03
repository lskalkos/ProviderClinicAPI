class ProviderClinic < ApplicationRecord
  UPPER_TIERS = %i{A B C}.freeze

  scope :upper_tiers, -> { where(tier: UPPER_TIERS) }
  scope :in_zipcodes, -> (zipcodes) { where(zipcode: zipcodes) }

  def self.by_tier_and_distance(zipcodes_by_distance = {})
    raise "Please provide a hash of zipcodes and their distances from a location" if zipcodes_by_distance.empty?

    # Encapsulate the knowledge of tiers and zipcodes to PartnerClinic scopes + constant.
    # That way, if we have to repeat or change this logic elsewhere in the code there is
    # one place we have to change (Single Responsibility Principle). I would also make
    # sure that there is a compound index on tier and zipcode on PartnerClinic in the
    # database, otherwise this could be a bottleneck for performance on the endpoint.
    nearby_zipcodes = zipcodes_by_distance.keys
    nearby_clinics = self.upper_tiers.in_zipcodes(nearby_zipcodes)

    clinics_by_distance = nearby_clinics.map do |clinic|
      {
        clinic: clinic,
        zipcode: clinic.zipcode,
        distance: zipcodes_by_distance[clinic.zipcode],
        tier: clinic.tier
      }
    end

    # Try to name variables as semantically as possible to help future
    # developers understand what the code is doing. Also use the wonderful
    # built-in Enumerable methods Ruby gives us to write the sort more
    # cleanly. Gets us past nested while.
    # Make use of .map instead of mutation arrays and hashes in place. I would definitely leave a comment here:
    # Sort clinics by tier first and then distance. If two clinics are in the same tier,
    # order the closest one first.
    clinics_by_distance.sort{|a, b| [a[:tier], a[:distance]] <=> [b[:tier], b[:distance]] }.map{|d| d[:clinic]}
  end
end
