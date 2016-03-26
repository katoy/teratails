class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :title, null: false
      t.timestamp :created, null: false
      t.timestamp :modified, null: false
      t.integer :count_reply, default: 0
      t.integer :count_clip, default: 0
      t.integer :count_pv, default: 0
      t.boolean :is_beginner, null: false
      t.boolean :is_accepted, null: false
      t.boolean :is_presentation, null: false
      t.references :user

      t.timestamps
    end

    add_index :questions, :user_id
  end

  def self.down
    drop_table :questions
  end
end
