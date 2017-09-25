Erp::Tours::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/tours" do
			resources :tours do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'					
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
				end
			end
			resources :categories do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'					
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
				end
			end
			resources :menus do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
					put 'move_up'
          put 'move_down'
				end
			end
		end
	end
end