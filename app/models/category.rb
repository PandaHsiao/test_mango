class Category

  #= Function ==============================================
  # record category article

  #= Future ================================================
  # 1.create_time
  # 3.change_time
  # 4.read_count
  # 5.status       : 0  draft
  #                  1  post

  #= MetaData ==============================================
  # 1.cid    : category_column object_id
  # 2.uid    : user object_id
  # 3.d      : create time (it will replace by create_time )
  # 4.title  : category title

  #= Method ================================================
  # 1.query_special_field
  #=========================================================

  include Mongoid::Document
  field :cid, type: String
  field :uid, type: String
  field :d, type: DateTime
  field :title, type: String

  embeds_many :category_datas

  def self.query_special_field_test(f, data)
    where(category_datas: {'$elemMatch' => {n: f, v: data}})
  end

  def self.query_special_field(category_id, category_filters)

    type_array = []
    name_array = []
    value_array = []

    query_array = []

    category_filters.each do |x|

      query_hash = {'$elemMatch' => {t: x['type'], n: x['name'], v: x['value']}}
      query_array.push(query_hash)
      #type_array.push()
      #name_array.push()
      #value_array.push()
    end

    #where(:cid => category_id, category_datas: {'$and' => query_array})
    where(:cid => category_id, category_datas: {'$all' =>query_array})
  end
end
