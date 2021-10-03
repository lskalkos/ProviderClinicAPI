class CreateProviderClinics < ActiveRecord::Migration[6.1]
  def change
    create_table :provider_clinics do |t|
      t.string :tier
      t.string :zipcode

      t.timestamps
    end
  end
end
