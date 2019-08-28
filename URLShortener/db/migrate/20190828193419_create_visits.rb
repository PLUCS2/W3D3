class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :user_id, null: false
      t.integer :short_url_id, null: false
    end

    add_index :visits, :short_url_id
    add_index :visits, :user_id
  end
end
