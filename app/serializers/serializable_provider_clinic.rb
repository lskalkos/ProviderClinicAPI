class SerializableProviderClinic < JSONAPI::Serializable::Resource
  type 'provider_clinics'
  attributes :tier, :zipcode
end
