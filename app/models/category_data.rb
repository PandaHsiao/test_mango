class CategoryData

  #= Function ==============================================
  # record category article data.

  #= MetaData ==============================================
  # 1.t : type
  # 2.n : field name
  # 3.v : field data

  include Mongoid::Document
  field :t, type: String
  field :n, type: String
  field :v, type: String

  embedded_in :category
end
