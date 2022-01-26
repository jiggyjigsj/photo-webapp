class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :uuid
      t.string :username
      t.integer :uid
      t.string :generated_path
      t.string :original_path
      t.timestamp :init_date
      t.timestamp :fin_date
      t.string :qid
      t.boolean :completed

      t.timestamps
    end
    add_index :photos, :uuid, unique: true
  end
end
