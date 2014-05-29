class CategoryData
  include Mongoid::Document
  field :t, type: String
  field :n, type: String
  field :v, type: String

  embedded_in :category
end
