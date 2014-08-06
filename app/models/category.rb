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

  def self.query_special_field(f, data)
    where(category_datas: {'$elemMatch' => {n: f, v: data}})
  end
end
