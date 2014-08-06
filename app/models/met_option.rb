class MetOption

  #= Function ==============================================
  # record category fields info.

  #= MetaData ==============================================
  # 1.n        : field type
  # 2.v        : field name
  # 3.sequence : field sequence
  #=========================================================

  include Mongoid::Document
  field :n, type: String
  field :v, type: String
  field :sequence, type: String

  embedded_in :category_column
end
