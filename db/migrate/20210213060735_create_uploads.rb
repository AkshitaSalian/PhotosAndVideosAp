class CreateUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads do |t|
      t.string :title
      t.text :description
      t.string :type
	  t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
