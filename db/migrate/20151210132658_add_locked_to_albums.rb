class AddLockedToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :locked, :boolean, default: false
  end
end
