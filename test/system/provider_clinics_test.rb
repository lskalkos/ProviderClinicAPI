require "application_system_test_case"

class ProviderClinicsTest < ApplicationSystemTestCase
  setup do
    @provider_clinic = provider_clinics(:one)
  end

  test "visiting the index" do
    visit provider_clinics_url
    assert_selector "h1", text: "Provider Clinics"
  end

  test "creating a Provider clinic" do
    visit provider_clinics_url
    click_on "New Provider Clinic"

    fill_in "Radius", with: @provider_clinic.radius
    fill_in "Zipcode", with: @provider_clinic.zipcode
    click_on "Create Provider clinic"

    assert_text "Provider clinic was successfully created"
    click_on "Back"
  end

  test "updating a Provider clinic" do
    visit provider_clinics_url
    click_on "Edit", match: :first

    fill_in "Radius", with: @provider_clinic.radius
    fill_in "Zipcode", with: @provider_clinic.zipcode
    click_on "Update Provider clinic"

    assert_text "Provider clinic was successfully updated"
    click_on "Back"
  end

  test "destroying a Provider clinic" do
    visit provider_clinics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Provider clinic was successfully destroyed"
  end
end
