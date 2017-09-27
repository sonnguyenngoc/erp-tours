module Erp
  module Tours
    module Backend
      class CategoriesController < Erp::Backend::BackendController
        before_action :set_category, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_categories, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /categories
        def index
        end
    
        # POST /categories/list
        def list
          @categories = Category.search(params).paginate(:page => params[:page], :per_page => 20)
          
          render layout: nil
        end
    
        # GET /categories/new
        def new
          @category = Category.new
        end
    
        # GET /categories/1/edit
        def edit
        end
    
        # POST /categories
        def create
          @category = Category.new(category_params)
          @category.creator = current_user
    
          if @category.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @category.name,
                value: @category.id
              }
            else
              redirect_to erp_tours.edit_backend_category_path(@category), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /categories/1
        def update
          if @category.update(category_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @category.name,
                value: @category.id
              }              
            else
              redirect_to erp_tours.edit_backend_category_path(@category), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /categories/1
        def destroy
          @category.destroy

          respond_to do |format|
            format.html { redirect_to erp_tours.backend_categories_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /categories/archive?id=1
        def archive
          @category.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /categories/archive?id=1
        def unarchive
          @category.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end        
                
        # DELETE ALL /categories/delete_all?ids=1,2,3
        def delete_all         
          @categories.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /categories/archive_all?ids=1,2,3
        def archive_all         
          @categories.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /categories/unarchive_all?ids=1,2,3
        def unarchive_all
          @categories.unarchive_all
          
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
              render json: Category.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_category
            @category = Category.find(params[:id])
          end
          
          def set_categories
            @categories = Category.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def category_params
            params.fetch(:category, {}).permit(:name, :parent_id, :description)
          end
      end
    end
  end
end