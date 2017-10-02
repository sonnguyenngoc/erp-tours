module Erp::Tours
  class TourBooking < ApplicationRecord
    validates :customer_name, :customer_phone, :customer_email, :customer_address, :presence => true
    belongs_to :tour, class_name: "Erp::Tours::Tour"
  end
end
