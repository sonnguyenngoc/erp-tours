class CreateErpToursMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_menus do |t|
      t.string :name
      t.integer :parent_id
      t.integer :custom_order
      t.integer :level
      t.boolean :is_main, default: false
      t.string :icon_main
      t.text :cache_search
      t.text :description
      t.string :meta_image
      t.string :meta_keywords
      t.string :meta_description
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users      

      t.timestamps
    end
  end
end
