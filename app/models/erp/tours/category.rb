module Erp::Tours
  class Category < ApplicationRecord
		validates :name, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :parent, class_name: "Erp::Tours::Category", optional: true
    has_many :children, class_name: "Erp::Tours::Category", foreign_key: "parent_id"

    after_save :update_level

    # get self and children ids
    def get_self_and_children_ids
      ids = [self.id]
      ids += get_children_ids_recursive
      return ids
		end

    # get children ids recursive
    def get_children_ids_recursive
      ids = []
      children.each do |c|
				if !c.children.empty?
					ids += c.get_children_ids_recursive
				end
				ids << c.id
			end
      return ids
		end

    # update level
    def update_level
			level = 1
			parent = self.parent
			while parent.present?
				level += 1
				parent = parent.parent
			end

			level
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

      # join with parent categories table for search categories
      query = query.joins("LEFT JOIN erp_tours_categories parents_erp_tours_categories ON parents_erp_tours_categories.id = erp_tours_categories.parent_id")
			
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

      query = query.limit(8).map{|category| {value: category.id, text: category.name} }
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

    # display name
    def parent_name
			parent.present? ? parent.name : ''
		end

		# display name with parent
    def full_name
			names = [self.name]
			p = self.parent
			while !p.nil? do
				names << p.name
				p = p.parent
			end
			names.reverse.join(" >> ")
		end

    # Get get all archive
    def self.all_unarchive
			self.where(archived: false)
		end
    
    # Get categories active
    def self.get_parent_categories
			self.where(archived: false)
					.where(parent_id: nil).order(custom_order: 'ASC')
		end
  end
end