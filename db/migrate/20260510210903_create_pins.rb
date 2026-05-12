class CreatePins < ActiveRecord::Migration[8.1]
  def change
    create_table :pins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :locality, null: false, foreign_key: true
      t.references :building, null: true, foreign_key: true
      t.string :kind, null: false, default: "rent"
      t.string :slug, null: false
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
      t.string :hood, null: false
      t.integer :bedrooms
      t.integer :rent_cents
      t.integer :listed_rent_cents
      t.integer :square_feet
      t.integer :move_in_year
      t.date :reported_on, null: false
      t.text :note
      t.string :source
      t.boolean :rent_controlled, default: false
      t.boolean :rent_stabilized, default: false
      t.boolean :parking_included, default: false
      t.boolean :utilities_included, default: false
      t.integer :broker_fee_cents
      t.text :tags
      t.integer :comments_count, default: 0
      t.integer :flags_count, default: 0

      t.timestamps
    end

    add_index :pins, :slug, unique: true
    add_index :pins, [ :latitude, :longitude ]
    add_index :pins, :reported_on
    add_index :pins, :rent_cents
    add_index :pins, :bedrooms

    add_check_constraint :pins, "kind IN ('rent', 'discussion')", name: "pins_kind_valid"
    add_check_constraint :pins, "rent_cents > 0 OR kind = 'discussion'", name: "pins_rent_required_for_rent"
    add_check_constraint :pins, "latitude >= -90 AND latitude <= 90", name: "pins_latitude_range"
    add_check_constraint :pins, "longitude >= -180 AND longitude <= 180", name: "pins_longitude_range"
  end
end
