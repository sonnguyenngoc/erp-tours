class CreateErpToursTours < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_tours do |t|
      t.string :image_url
      t.string :name
      t.decimal :price
      t.boolean :is_discount
      t.decimal :price_discount
      t.decimal :percent_discount
      t.datetime :date_discount_start
      t.datetime :date_discount_end
      t.boolean :is_hot
      t.string :time_line
      t.string :area_position
      t.string :map_position
      t.string :departure_schedule
      t.text :description
      t.text :content
      t.string :transportation
      t.integer :star
      t.string :tour_program
      t.string :meta_image
      t.string :meta_keywords
      t.string :meta_description
      t.boolean :archived, default: false
      t.references :category, index: true, references: :erp_tours_categories
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
