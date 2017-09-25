user = Erp::User.first

Erp::Tours::Menu.all.destroy_all
Erp::Tours::Tour.all.destroy_all
Erp::Tours::Category.all.destroy_all

