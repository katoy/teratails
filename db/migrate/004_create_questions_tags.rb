class CreateQuestionsTags < ActiveRecord::Migration
  def self.up
    create_table :questions_tags do |t|
      t.references :question
      t.references :tag
    end

    add_index :questions_tags, :question_id
    add_index :questions_tags, :tag_id
  end

  def self.down
    drop_table :questions_tags
  end
end
