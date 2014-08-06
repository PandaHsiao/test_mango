class CategoryColumn

  #= Function ==============================================
  # each category has different fields,
  # so use MongoDB to solve Dynamic MetaData require.
  # the embed sets are fields info.

  #= Future ================================================
  # 1.creator
  # 2.changer
  # 3.create_time
  # 4.change_time
  # 5.day_hot_count : every day get yesterday most hot tag count for Website Search
  #
  # 6.fields_option : for search speed, when category create or change,
  #                   cover fields_option by new fields option,
  #
  # 7.day_hot_tag   : update by yesterday search count. (require filter)
  # 8.week_hot_tag  : update by last week search count. (require filter)
  # 9.month_hot_tag : update by last month search count. (require filter)


  #= MetaData ==============================================
  # 1.name        : category name
  #
  # 2.status      : 0 disable
  #                 1 enable
  #
  # 3.met_options : fields info
  #=========================================================

  include Mongoid::Document
  field :name, type: String
  field :status, type: String

  embeds_many :met_options
end
