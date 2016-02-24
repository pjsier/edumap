class Code < ActiveRecord::Base
  filterrific :default_filter_params => { :sorted_by => 'created_at_desc' },
                :available_filters => %w[
                  sorted_by
                  search_query
                  with_standard_id
                  with_created_at_gte
                ]

  self.per_page = 10

  belongs_to :standard
  has_and_belongs_to_many :lessons

  scope :with_standard_id, -> (ids) { where(standard_id: ids) }
  scope :with_created_at_gte, -> (ref_date) { where('created_at >= ?', ref_date) }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order(created_at: direction)
    when /^name_/
      order("LOWER(identifier) #{direction}")
    when /^standard_abbreviation_/
      joins(:standard).order("LOWER(standards.abbreviation) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Identifier (a-z)', 'identifier_asc'],
      ['Standard (a-z)', 'standard_abbreviation_asc'],
      ['Creation date (newest first)', 'created_at_desc'],
      ['Creation date (oldest first)', 'created_at_asc'],
    ]
  end
end
