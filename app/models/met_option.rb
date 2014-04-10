class MetOption
  include Mongoid::Document
  field :n, type: String
  field :v, type: String
  field :sequence, type: String

  embedded_in :category_column
end
