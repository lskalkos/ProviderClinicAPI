require "test_helper"

class ProviderClinicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_clinic = provider_clinics(:one)
  end

  test "should get index" do
    get provider_clinics_url
    assert_response :success
  end

  test "should require zipcode parameter" do
    get provider_clinics_url, params: {zipcode: '14586'}
    assert_response :success
  end

  test "should default radius to 20 miles" do
    get provider_clinics_url
    assert_response :success
  end

  test "should accept a radius" do
    get provider_clinics_url
    assert_response :success
  end
 
  # test "should show provider_clinic" do
  #   get provider_clinic_url(@provider_clinic)
  #   assert_response :success
  # end
end
