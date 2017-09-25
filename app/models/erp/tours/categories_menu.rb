module Erp::Tours
  class CategoriesMenu < ApplicationRecord
    belongs_to :category, class_name: "Erp::Tours::Category"
    belongs_to :menu, class_name: "Erp::Tours::Menu"
  end
end
