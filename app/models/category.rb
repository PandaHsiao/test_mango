class Category
  include Mongoid::Document
  field :cid, type: String
  field :uid, type: String
  field :d, type: DateTime
  field :title, type: String

  embeds_many :category_datas

  def self.query_special_field(f, data)
    where(category_datas: {'$elemMatch' => {n: f, v: data}})
  end
end
