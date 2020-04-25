class RenameImageNameColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :image_name, :image
  end
end
