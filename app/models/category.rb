class Category
  include Mongoid::Document
  field :name, type: String

  embeds_many :mets

  def self.query_special_field(f, data)
    where(mets: {'$elemMatch' => {n: f, v: data}})
  end
end
