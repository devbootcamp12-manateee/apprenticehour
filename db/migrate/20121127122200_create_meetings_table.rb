class CreateMeetingsTable < ActiveRecord::Migration
  create_table :meetings do |t|
    t.integer :mentor_id
    t.integer :mentee_id
  end
end