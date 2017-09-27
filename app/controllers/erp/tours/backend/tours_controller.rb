module Erp
  module Tours
    module Backend
      class ToursController < Erp::Backend::BackendController
        before_action :set_tour, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_tours, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /tours
        def index
        end
    
        # POST /tours/list
        def list
          @tours = Tour.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /tours/new
        def new
          @tour = Tour.new
          20.times do
            @tour.tour_images.build
          end
          @tour.date_discount_start = ''
          @tour.date_discount_end = ''
        end
    
        # GET /tours/1/edit
        def edit
          (20 - @tour.tour_images.count).times do
            @tour.tour_images.build
          end
        end
    
        # POST /tours
        def create
          @tour = Tour.new(tour_params)
          @tour.creator = current_user
    
          if @tour.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @tour.name,
                value: @tour.id
              }
            else
              redirect_to erp_tours.edit_backend_tour_path(@tour), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /tours/1
        def update
          if @tour.update(tour_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @tour.name,
                value: @tour.id
              }              
            else
              redirect_to erp_tours.edit_backend_tour_path(@tour), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /tours/1
        def destroy
          @tour.destroy

          respond_to do |format|
            format.html { redirect_to erp_tours.backend_tours_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /tours/archive?id=1
        def archive
          @tour.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /tours/archive?id=1
        def unarchive
          @tour.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end        
                
        # DELETE ALL /tours/delete_all?ids=1,2,3
        def delete_all         
          @tours.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /tours/archive_all?ids=1,2,3
        def archive_all         
          @tours.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /tours/unarchive_all?ids=1,2,3
        def unarchive_all
          @tours.unarchive_all
          
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
              render json: Tour.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_tour
            @tour = Tour.find(params[:id])
          end
          
          def set_tours
            @tours = Tour.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def tour_params
            params.fetch(:tour, {}).permit(
                                          # TOUR INFO
                                          :image_url, :name, :price, :description, :content, :star,
                                          :tour_program, :category_id, :area_position, :map_position, :transportation,
                                          # TOUR CHECK STATUS
                                          :is_hot,
                                          # TOUR DISCOUNT
                                          :is_discount, :price_discount, :percent_discount,
                                          :date_discount_start, :date_discount_end,
                                          # TOUR SCHEDULE
                                          :departure_schedule, :time_line,                                          
                                          # TOUR SEO
                                          :meta_image,:meta_keywords, :meta_description,
                                          # TOUR IMAGES
                                          :tour_images_attributes => [:id, :image_url, :image_url_cache, :tour_id, :_destroy])
          end
      end
    end
  end
end