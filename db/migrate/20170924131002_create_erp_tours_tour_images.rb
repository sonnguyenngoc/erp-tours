class CreateErpToursTourImages < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_tour_images do |t|
      t.string :image_url
      t.references :tour, index: true, references: :erp_tours_tours

      t.timestamps
    end
  end
end
