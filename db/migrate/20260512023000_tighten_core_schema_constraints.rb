class TightenCoreSchemaConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :localities, :name, false
    change_column_null :localities, :city, false
    change_column_null :localities, :state, false
    change_column_null :localities, :slug, false
    add_index :localities, :slug, unique: true unless index_exists?(:localities, :slug, unique: true)
    add_index :localities, :name unless index_exists?(:localities, :name)

    change_column_null :buildings, :street_number, false
    change_column_null :buildings, :street, false
    change_column_null :buildings, :city, false
    change_column_null :buildings, :state, false
    change_column_null :buildings, :postal_code, false
    change_column_null :buildings, :latitude, false
    change_column_null :buildings, :longitude, false
    add_index :buildings, [:latitude, :longitude] unless index_exists?(:buildings, [:latitude, :longitude])
    add_check_constraint :buildings, "latitude >= -90 AND latitude <= 90", name: "buildings_latitude_range"
    add_check_constraint :buildings, "longitude >= -180 AND longitude <= 180", name: "buildings_longitude_range"

    change_column_null :pins, :comments_count, false, 0
    change_column_null :pins, :flags_count, false, 0
    change_column_null :pins, :rent_controlled, false, false
    change_column_null :pins, :rent_stabilized, false, false
    change_column_null :pins, :parking_included, false, false
    change_column_null :pins, :utilities_included, false, false
  end
end
