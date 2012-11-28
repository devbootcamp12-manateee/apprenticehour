class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :mentee_id
      t.integer :mentor_id
      t.integer :topic_id
      t.string :description
      t.string :neighborhood
      t.string :status

      t.timestamps
    end
  end
end
