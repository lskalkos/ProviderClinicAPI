# frozen_string_literal: true

class ProviderClinicsController < ApplicationController
  DEFAULT_CLINIC_RADIUS = 20
  deserializable_resource :provider_clinic

  # GET /provider_clinics or /provider_clinics.json
  def index
    return render status: 422 if params[:zipcode].nil?

    nearby_clinics = ProviderClinic.by_tier_and_distance(zipcodes_by_distance)
    render jsonapi: nearby_clinics, status: :ok
  end

  private

  def zipcodes_by_distance
    radius = params[:radius] || DEFAULT_CLINIC_RADIUS
    nearby_zipcodes = ZipcodeAPI::Client.zipcodes_within_radius(params[:zipcode], radius)
    Hash[nearby_zipcodes.map { |z| [z['zip_code'], z['distance']] }]
  end
end
