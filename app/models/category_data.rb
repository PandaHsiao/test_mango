class CategoryData
  include Mongoid::Document
  field :n, type: String
  field :v, type: String
  field :d, type: String

  embedded_in :category_column
end
