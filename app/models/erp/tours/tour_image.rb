module Erp::Tours
  class TourImage < ApplicationRecord
    mount_uploader :image_url, Erp::Tours::TourImageUploader
    belongs_to :tour, class_name: "Erp::Tours::Tour"
    
    default_scope {
      order(created_at: :asc)
    }
  end
end
