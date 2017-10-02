class CreateErpToursTourBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_tours_tour_bookings do |t|
      t.string :customer_name
      t.string :customer_phone
      t.string :customer_email
      t.string :customer_address
      t.string :note
      t.string :number_people_1, default: 1
      t.string :number_people_2, default: 0
      t.string :number_people_3, default: 0
      t.string :number_people_4, default: 0
      t.string :tour_name
      t.string :tour_price
      t.references :tour, index: true, references: :erp_tours_tours

      t.timestamps
    end
  end
end
