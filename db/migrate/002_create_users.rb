class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :display_name, null: false
      t.string :photo
      t.integer :score

      t.timestamps
    end

    add_index :users, :display_name, unique: true
  end

  def self.down
    drop_table :users
  end
end
