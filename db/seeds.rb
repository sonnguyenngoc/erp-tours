user = Erp::User.first

Erp::Tours::Menu.all.destroy_all
Erp::Tours::Tour.all.destroy_all
Erp::Tours::Category.all.destroy_all

category_1_list = ["Tour Miền Bắc", "Tour Miền Trung", "Tour Miền Nam", "Tour Miền Tây",
                  "Tour Hành Hương", "Tour Tây Nguyên", "Tour Yêu Cầu"]
category_2_list = ["Tour Châu Á", "Tour Châu Âu", "Tour Châu Mỹ", "Tour Châu Úc",
                  "Tour Châu Phi"]

category_1 = Erp::Tours::Category.create(
  name: "Tour Trong Nước",
  creator_id: user.id
)
category_2 = Erp::Tours::Category.create(
  name: "Tour Nước Ngoài",
  creator_id: user.id
)
category_1_list.each do |category|
  Erp::Tours::Category.create(
    name: category,
    creator_id: user.id,
    parent_id: category_1.id
  )
end
category_2_list.each do |category|
  Erp::Tours::Category.create(
    name: category,
    creator_id: user.id,
    parent_id: category_2.id
  )
end
menu_1 = Erp::Tours::Menu.create(
  name: "Tour Du Lịch Trong Nước",
  creator_id: user.id
)
menu_2 = Erp::Tours::Menu.create(
  name: "Tour Du Lịch Nước Ngoài",
  creator_id: user.id
)
category_1_list.each do |category|
  Erp::Tours::Menu.create(
    name: category,
    creator_id: user.id,
    parent_id: menu_1.id
  )
end
category_2_list.each do |category|
  Erp::Tours::Menu.create(
    name: category,
    creator_id: user.id,
    parent_id: menu_2.id
  )
end