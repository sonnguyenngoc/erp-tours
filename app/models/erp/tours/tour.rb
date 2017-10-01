module Erp::Tours
  class Tour < ApplicationRecord
		mount_uploader :image_url, Erp::Tours::TourImageUploader
		mount_uploader :meta_image, Erp::Tours::TourImageUploader
		mount_uploader :tour_program, Erp::Tours::TourProgramUploader
		
		validates :name, :category_id, :hotel, :transportation, :price, :time_line, :area_position, :map_position, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category, class_name: "Erp::Tours::Category"
    
    has_many :tour_images, dependent: :destroy
    accepts_nested_attributes_for :tour_images, :reject_if => lambda { |a| a[:image_url].blank? and a[:image_url_cache].blank? }, :allow_destroy => true
		
		def self.get_active
			self.where(archived: false)
		end
		
		def self.get_discount_tours
			self.get_active.where(is_discount: true)
		end
		
		def self.get_hot_tours
			self.get_active.where(is_hot: true)
		end
		
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      # show archived items condition - default: false
			show_archived = false

			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						# in case filter is show archived
						if cond[1]["name"] == 'show_archived'
							# show archived items
							show_archived = true
						else
							or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
						end
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # join with categories table for search tours
       query = query.joins(:category)
			
			# join with users table for search creator
      query = query.joins(:creator)
			
      # showing archived items if show_archived is not true
			query = query.where(archived: false) if show_archived == false

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|tour| {value: tour.id, text: tour.name} }
    end

    def archive
			update_columns(archived: true)
		end

		def unarchive
			update_columns(archived: false)
		end

    def self.archive_all
			update_all(archived: true)
		end

    def self.unarchive_all
			update_all(archived: false)
		end
    
    def category_name
			category.present? ? category.name : ''
		end

    # display name
    def tour_name
			self.name
		end

    # Get get all archive
    def self.all_unarchive
			self.where(archived: false)
		end
  end
end