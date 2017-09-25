class CreateErpToursCategoriesMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_categories_menus do |t|
      t.references :category, index: true, references: :erp_tours_categories
      t.references :menu, index: true, references: :erp_tours_menus

      t.timestamps
    end
  end
end
