class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pin, null: false, foreign_key: true
      t.text :body
      t.string :relationship

      t.timestamps
    end
  end
end
