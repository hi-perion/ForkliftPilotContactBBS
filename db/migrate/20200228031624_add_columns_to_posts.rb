class AddColumnsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :pilot, :string
    add_column :posts, :machine, :string
    add_column :posts, :affiliation, :string
    add_column :posts, :speech, :text
    add_column :posts, :series, :string
    add_column :posts, :image_name, :string
    add_column :posts, :user_id, :integer
  end
end
