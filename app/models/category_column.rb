class CategoryColumn
  include Mongoid::Document
  field :name, type: String
  field :status, type: String

  embeds_many :met_options
  embeds_many :category_datas
end
