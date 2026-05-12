class CreateLocalities < ActiveRecord::Migration[8.1]
  def change
    create_table :localities do |t|
      t.string :name, null: false
      t.string :city, null: false, default: "Chicago"
      t.string :state, null: false, default: "IL"
      t.string :slug, null: false

      t.timestamps
    end

    add_index :localities, :slug, unique: true
    add_index :localities, :name
  end
end
