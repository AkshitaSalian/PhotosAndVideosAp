class CreateFavourites < ActiveRecord::Migration[6.0]
  def change
    create_table :favourites do |t|
    	t.belongs_to :user, index: true, foreign_key: true
    	t.belongs_to :upload, index: true, foreign_key: true
      t.timestamps
    end
  end
end
