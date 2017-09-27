module Erp
  module Tours
    module Backend
      class MenusController < Erp::Backend::BackendController
        before_action :set_menu, only: [:move_up, :move_down, :archive, :unarchive, :edit, :update, :destroy]
        before_action :set_menus, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /menus
        def index
        end

        # POST /menus/list
        def list
          @menus = Menu.search(params).paginate(:page => params[:page], :per_page => 20)

          render layout: nil
        end

        # GET /menus/new
        def new
          @menu = Menu.new
        end

        # GET /menus/1/edit
        def edit
        end

        # POST /menus
        def create
          @menu = Menu.new(menu_params)
          @menu.creator = current_user
          
          if @menu.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @menu.name,
                value: @menu.id
              }
            else
              redirect_to erp_tours.edit_backend_menu_path(@menu), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /menus/1
        def update
          if @menu.update(menu_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @menu.name,
                value: @menu.id
              }
            else
              redirect_to erp_tours.edit_backend_menu_path(@menu), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /menus/1
        def destroy
          @menu.destroy

          respond_to do |format|
            format.html { redirect_to erp_tours.backend_menus_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE /menus/archive?id=1
        def archive
          @menu.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE /menus/archive?id=1
        def unarchive
          @menu.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE ALL /menus/delete_all?ids=1,2,3
        def delete_all
          @menus.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE ALL /menus/archive_all?ids=1,2,3
        def archive_all
          @menus.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE ALL /menus/unarchive_all?ids=1,2,3
        def unarchive_all
          @menus.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: Menu.dataselect(params[:keyword])
            }
          end
        end

        # Move up /menus/up?id=1
        def move_up
          @menu.move_up

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        # Move down /menus/up?id=1
        def move_down
          @menu.move_down

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_menu
            @menu = Menu.find(params[:id])
          end

          def set_menus
            @menus = Menu.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def menu_params
            params.fetch(:menu, {}).permit(:is_main, :icon_main, :name, :parent_id, :description, :meta_image,
                                           :meta_keywords, :meta_description, category_ids: [])
          end
      end
    end
  end
end