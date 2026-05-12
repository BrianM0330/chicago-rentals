class CreateBuildings < ActiveRecord::Migration[8.1]
  def change
    create_table :buildings do |t|
      t.string :display_name, null: false
      t.string :street_number
      t.string :street
      t.string :city, null: false, default: "Chicago"
      t.string :state, null: false, default: "IL"
      t.string :postal_code, null: false
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
      t.references :locality, null: false, foreign_key: true

      t.timestamps
    end

    add_index :buildings, [:latitude, :longitude]
    add_check_constraint :buildings, "latitude >= -90 AND latitude <= 90", name: "buildings_latitude_range"
    add_check_constraint :buildings, "longitude >= -180 AND longitude <= 180", name: "buildings_longitude_range"
  end
end
