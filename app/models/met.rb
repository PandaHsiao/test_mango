class Met
  include Mongoid::Document
  field :n, type: String
  field :v, type: String

  embedded_in :category
end
