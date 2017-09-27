class CreateErpToursCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_categories do |t|
      t.string :name
      t.integer :parent_id
      t.text :description
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users
      
      t.timestamps
    end
  end
end