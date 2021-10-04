class ProviderClinic < ApplicationRecord
  UPPER_TIERS = %i{A B C}.freeze

  # I encapsulated the knowledge of tiers and zipcodes to PartnerClinic scopes + a constant.
  # That way, if we have to repeat or change this logic elsewhere in the code there is
  # one place we have to change (Single Responsibility Principle). I would also make
  # sure that there is a compound index on tier and zipcode on PartnerClinic, in order to
  # improve the performance of each individual query and both queries together.
  # The performance of IN clauses however is non-determinstic even with indices,
  # so I would keep an eye on this query and consider how to
  # make it better given the current amount of data, how often it changes, and the query goals.
  scope :upper_tiers, -> { where(tier: UPPER_TIERS) }
  scope :in_zipcodes, -> (zipcodes) { where(zipcode: zipcodes) }

  # Queries for provider clinics in a set of given zipcodes, and then sorts those clinics by their tier first and then the distance of that zipcode.
  # If two clinics are in the same tier, it orders the closest one first.
  # I would definitely leave a comment on a method like to make what it is doing as clear as possible.
  #
  # @param zipcodes_by_distance [Hash] a dictionary of zipcodes and their distance in decimals
  # @return [Array<ProviderClinic>]
  def self.by_tier_and_distance(zipcodes_by_distance = {})
    raise "Please provide a hash of zipcodes and their distances from a location" if zipcodes_by_distance.empty?

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
    # cleanly instead of using the confusing nested `while` loop.
    # Make use of .map instead of mutation arrays and hashes in place.
    clinics_by_distance.sort{|a, b| [a[:tier], a[:distance]] <=> [b[:tier], b[:distance]] }.map{|d| d[:clinic]}
  end
end
