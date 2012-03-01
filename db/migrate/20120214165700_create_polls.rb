class CreatePolls < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.integer :user_id
      t.string :overall_grade
      t.string :personalization
      t.string :relevance
      t.string :value_proposition
      t.string :design
      t.string :other
      t.string :responder_name
      t.string :responder_email
      t.text :comments
      t.string :next_steps

      t.timestamps
    end
    add_index :polls, [:user_id, :created_at]
  end
  
  def self.down
    drop_table :polls
  end
end
