class ChangeVisitTimestamps < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :created_at, :datetime
  end
end
