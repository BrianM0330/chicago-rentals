class CreatePinFlags < ActiveRecord::Migration[8.1]
  def change
    create_table :pin_flags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pin, null: false, foreign_key: true
      t.string :reason, null: false

      t.timestamps
    end

    add_index :pin_flags, [:user_id, :pin_id, :reason], unique: true
  end
end
