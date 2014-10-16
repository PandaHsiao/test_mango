class HomeController < ApplicationController
  layout 'home'

  #===================== Block Function =====================
  # Block Relation : abandoned
  #
  # Function : category_list
  #   Trigger: get url
  #   Func   : show created category list
  #   Reason : replace by home/index partial view
  def category_list
    @categorys = CategoryColumn.all.entries
    xxx = 0
  end


  #===================== Block Function =====================
  # Block Relation : db operation.
  #
  # Function : clear_db
  #   Trigger: get url
  #   Func   : clear all db but not include user db

  def clear_db
    aa = CategoryColumn.all.entries
    aa.each do |c|
      c.destroy
    end

    bb = Category.all.entries
    bb.each do |e|
      e.destroy
    end
  end


  #===================== Block Function =====================
  # Block Relation : test
  #
  # Function : test_category
  #   Trigger: get url
  #   Func   : test query speed

  def test_category
    #(1..10).each do |x|
    #  c = Category.new
    #  c.name = 'Paintings'
    #  fs = []
    #  (1..10).each do |y|
    #    fs.push(Met.new(:n => y, :v => rand(0..1000)))
    #  end
    #
    #  c.category_datas = fs
    #  c.save
    #end

    #xx = Category.where('category_datas.n' => '1').('category_datas.v' => '800').count
    #xx = Category.where(category_datas: {'$elemMatch' => {v: '800',n: '1'}})

    xx = Category.query_special_field('1', '800').all.entries
    xx = 0
  end


  #===================== Block Function =====================
  # Block Relation : index
  #
  # Function : index
  #   Trigger: get url, url.json
  #   Func   : default is category_list, now for template test

  def index
    @categorys = CategoryColumn.all.entries
    respond_to do |format|
      format.html {
        @partial = render_to_string('home/category_list', :layout => false)
        render :template => 'home/index'
      }
      format.json {
        render json: {:partial => render_to_string('home/category_list', :layout => false, :locals => {:categorys => @categorys}, :formats => [:html])}, :status => 200
      }
    end
  end

  def uindex
    # user index
  end


  #===================== Block Function =====================
  # Block Relation : category New, Save, TODO (Modify), TODO (Delete)
  #
  # Function : new_category
  #   Trigger: get url, url.json
  #   Func   : show new category view
  #
  # Function : save_category
  #   Trigger: post url
  #   Func   : save new category data to db

  def new_category

    xxx = 0

    respond_to do |format|
      format.html {
        @partial = render_to_string('home/new_category', :layout => false)
        render :template => 'home/index'
      }
      format.json {
        render json: {:partial => render_to_string('home/new_category', :layout => false, :formats => [:html])}, :status => 200
      }
    end
  end

  def save_category
    category_data = params[:category_data]

    if category_data.blank?
      save_category_response(false)
    else
      result = parse_category_data_for_save(category_data)
      save_category_response(result)
    end
  end


  def parse_category_data_for_save(category_data)

    category_column = CategoryColumn.new
    met_options = []

    begin
      category_data.each do |x|
        sequence = x[0]
        obj = x[1]
        obj_array = obj.to_a

        #in_option = false       # when first is checkbox, radiobox, select then the after item is option, until item[0] return to some other obj name

        obj_array.each do |item|
          obj_type = item[0]
          mo = MetOption.new

          if obj_type == 'category_name'
            category_column.name = item[1].strip
            category_column.status = '0' # 0 disable, 1 enable

            exist_category = CategoryColumn.where(:name => category_column.name)
            if exist_category.present?
              return false
            end

          elsif obj_type == 'textbox_name'
            mo.n = 'textbox'
            mo.v = item[1].strip
            mo.sequence = sequence
            met_options.push(mo)
          elsif obj_type == 'textarea_name'
            mo.n = 'textarea'
            mo.v = item[1].strip
            mo.sequence = sequence
            met_options.push(mo)
          elsif obj_type == 'checkbox_name'
            mo.n = 'checkbox'
            mo.v = item[1].strip
            mo.sequence = sequence
            met_options.push(mo)
          elsif obj_type == 'radiobox_name'
            mo.n = 'radiobox'
            mo.v = item[1].strip
            mo.sequence = sequence
            met_options.push(mo)
          elsif obj_type == 'select_name'
            mo.n = 'select'
            mo.v = item[1].strip
            mo.sequence = sequence
            met_options.push(mo)
          elsif obj_type.include? "option"
            mo.n = item[0]
            mo.v = item[1].strip
            met_options.push(mo)
          end
        end
      end

      if met_options.blank?
        return false
      else
        category_column.met_options = met_options
        category_column.save
        return true
      end
    rescue => e
      return false
    end

  end

  def save_category_response(result)
    @categorys = CategoryColumn.all.entries

    respond_to do |format|
      format.html {
        @partial = render_to_string('home/category_list', :layout => false)
        render :template => 'home/index'
      }
      format.json {
        @result = result
        @data = nil

        if result
          @data = '新增類別成功'
        else
          @data = '新增類別失敗，類別名稱重複或系統異常'
        end

        render json: {:result => @result, :data => @data, :partial => render_to_string('home/category_list', :layout => false, :locals => {:categorys => @categorys}, :formats => [:html])}, :status => 200
        #render json: { :result => @result  ,:data => @data }
      }
    end
  end

  def modify_category
  end

  def delete_category
    category_id = params[:category_id]

    query_categorys = CategoryColumn.where(:_id => category_id)

    if query_categorys.present?

      begin
        select_category = query_categorys.first

        select_category_name = select_category.name
        select_category.destroy

        @categorys = CategoryColumn.all.entries

        render json: {:result => true, :data => select_category_name, :partial => render_to_string('home/category_list', :layout => false, :locals => {:categorys => @categorys}, :formats => [:html])}, :status => 200

      rescue => e
        render json: {:result => false, :partial => render_to_string('home/category_list', :layout => false, :locals => {:categorys => @categorys}, :formats => [:html])}, :status => 200
      end
    end

  end


  #===================== Block Function =====================
  # Block Relation : curio article list, New, Save, TODO (Modify), TODO (Delete)
  #
  # Function : curio_list
  #   Trigger: get url, url.json
  #   Func   : show created curios view
  #
  # Function : new_curio
  #   Trigger: get url, url.json
  #   Func   : show new curio view
  #
  # Function : save_curio
  #   Trigger: post url
  #   Func   : save new curio data to db

  def curio_list
    categorys = CategoryColumn.all.entries

    @categorys_option = []
    first_category_id = nil
    if categorys.present?


      categorys.each do |x|
        if first_category_id.blank?
          first_category_id = x['_id']
        end
        @categorys_option.push([x.name, x['_id']])
      end
    end

    select_articles = Category.where(:cid => first_category_id)
    select_category = CategoryColumn.where(:_id => first_category_id).first

    @view_string = get_view_curios(select_articles, select_category)


    respond_to do |format|
      format.html {
        @partial = render_to_string('home/curio_list', :layout => false)
        render :template => 'home/index'
        return
      }
      format.json {
        render json: {:partial => render_to_string('home/curio_list', :layout => false, :locals => {:categorys_option => @categorys_option, :view_string => @view_string}, :formats => [:html])}, :status => 200
        return
      }
    end
  end

  def new_curio
    categorys = CategoryColumn.all.entries

    @categorys_option = []
    default_format = nil
    if categorys.present?
      first_category = categorys.first
      default_format = first_category['met_options']

      categorys.each do |x|
        @categorys_option.push([x.name, x['_id']])
      end
    else

    end


    @view_string = get_view_category(default_format)

    begin
      respond_to do |format|
        format.html {
          @partial = render_to_string('home/new_curio', :layout => false)
          render :template => 'home/index'
          return
        }
        format.json {
          #render json: {:partial => render_to_string('home/new_curio', :layout => false, :locals => { :categorys => @categorys, :categorys_option => @categorys_option, :view_string => @view_string }, :formats=>[:html]) } , :status => 200
          render json: {:partial => render_to_string('home/new_curio', :layout => false, :locals => {:categorys_option => @categorys_option, :view_string => @view_string}, :formats => [:html])}, :status => 200
          return }
      end
    rescue => e
      xxx = e.message
      xxx = 0
    end
  end

  def save_curio
    curio_data = params[:curio_data]

    if curio_data.blank?
      save_curio_response(false, nil)
    else
      category_id = parse_curio_data_for_save(curio_data)

      if category_id.present?
        save_curio_response(true, category_id)
      else
        save_curio_response(false, nil)
      end
    end
  end

  def parse_curio_data_for_save(curio_data)
    category = Category.new
    category_datas = []

    begin
      curio_data.each do |x|
        #sequence = x[0]   not need to save sequence just say x[0] what is
        obj = x[1]
        obj_array = obj.to_a

        obj_array.each do |item|
          obj_type = item[0]
          cd = CategoryData.new

          if obj_type == 'category_id'
            category.cid = item[1].strip
            category.d = Time.now
            #category.uid =     TODO save create user id
          elsif obj_type.include?('title')
            category.title = item[1].strip
          elsif obj_type.include?('textbox')
            cd.t = 'textbox'
            arr_name = obj_type.split('_')
            cd.n = arr_name[1]
            cd.v = item[1].strip
            category_datas.push(cd)
          elsif obj_type.include?('textarea')
            cd.t = 'textarea'
            arr_name = obj_type.split('_')
            cd.n = arr_name[1]
            cd.v = item[1].strip
            category_datas.push(cd)
          elsif obj_type.include?('checkbox')
            cd.t = 'checkbox'
            arr_name = obj_type.split('_')
            cd.n = arr_name[1]
            cd.v = item[1].strip
            category_datas.push(cd)
          elsif obj_type.include?('radiobox')
            cd.t = 'radiobox'
            arr_name = obj_type.split('_')
            cd.n = arr_name[1]
            cd.v = item[1].strip
            category_datas.push(cd)
          elsif obj_type.include?('select')
            cd.t = 'select'
            arr_name = obj_type.split('_')
            cd.n = arr_name[1]
            cd.v = item[1].strip
            category_datas.push(cd)
          end
        end
      end

      category.category_datas = category_datas
      category.save
      return category.cid
    rescue => e
      return nil
    end

  end

  def save_curio_response(result, category_id)
    categorys = CategoryColumn.all.entries

    @categorys_option = []
    first_category_id = nil
    if categorys.present?


      categorys.each do |x|
        if first_category_id.blank?
          first_category_id = x['_id']
        end
        @categorys_option.push([x.name, x['_id']])
      end
    end

    select_articles = Category.where(:cid => category_id)
    select_category = CategoryColumn.where(:_id => category_id).first

    @view_string = get_view_curios(select_articles, select_category)


    respond_to do |format|
      format.html {
        @partial = render_to_string('home/curio_list', :layout => false)
        render :template => 'home/index'
        return
      }
      format.json {
        render json: {:result => true, :data => '新增項目成功', :category_id => category_id, :partial => render_to_string('home/curio_list', :layout => false, :locals => {:categorys_option => @categorys_option, :view_string => @view_string}, :formats => [:html])}, :status => 200
        return
      }
    end


  end


  #===================== Block Function =====================
  # Main Func: use category_column object_id to find category cid document,
  #            and render all result for grid with json type or html.

  # Floor1   : get_curios_view
  #   Trigger: 販賣清單，切換下拉式選單
  #   Func   : same Main Func.

  # Floor2   : get_view_curios
  #   Trigger: internal calls
  #   Func   : use category format, to render json ,html.

  def get_curios_view
    cid = params[:object_id]
    select_articles = Category.where(:cid => cid)
    select_category = CategoryColumn.where(:_id => cid).first

    view_string = get_view_curios(select_articles, select_category)

    render json: {:partial => view_string}
  end

  def get_view_curios(select_articles, select_category)
    view_string = nil
    @curios = select_articles

    if select_category.present?
      select_format = select_category['met_options']
      view_string = parse_meta_for_filter(select_format)
    end


    respond_to do |format|
      format.html { view_string = view_string + render_to_string('home/curios', :layout => false, :locals => {:curios => @curios}) }
      format.json { view_string = view_string + render_to_string('home/curios', :layout => false, :locals => {:curios => @curios}, :formats => [:html]) }
    end

    return view_string
  end


  #===================================

  def get_article_view
    select_article = Category.where(:_id => params[:object_id]).first

    view_string = get_view_article(select_article)

    render json: {:partial => view_string}
  end

  def get_view_article(select_article)
    view_string = nil

    select_category = CategoryColumn.where(:_id => select_article.cid).first

    if select_category.present?
      select_format = select_category['met_options']
      view_string = parse_format(select_format, select_article)
    end

    return view_string
  end


  def parse_meta_for_filter(select_format)
    @data = [] #option use, only radiobox, checkbox, select option,
    @name = nil #item label name

    data_type = nil
    view_string = nil

    select_format.each_with_index do |x, i|
      obj_type = x['n']

      if obj_type == 'checkbox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        data_type = obj_type
      elsif obj_type == 'radiobox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        data_type = obj_type
      elsif obj_type == 'select'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        data_type = obj_type
      elsif obj_type.include? "option"
        @data.push(x['v'])

        if i == select_format.length - 1
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
        end
      end
    end

    return view_string
  end

  def parse_format(select_format, select_article)
    article_datas = select_article['category_datas']
    @data = [] #option use, only radiobox, checkbox, select option,
    @name = nil #item label name
    @value = nil
    data_type = nil
    view_string = nil

    select_format.each_with_index do |x, i|
      obj_type = x['n']

      if obj_type == 'textbox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        temp_value = check_field(obj_type, @name, article_datas)
        if temp_value.present?
          @value = temp_value
        else
          @value = nil
        end

        respond_to do |format|
          format.html { view_string = "#{view_string} #{render_to_string('home/textbox_value', :layout => false, :locals => {:name => @name})}" }
          format.json { view_string = "#{view_string} #{render_to_string('home/textbox_value', :layout => false, :locals => {:name => @name, :value => @value}, :formats => [:html])}" }
        end
      elsif obj_type == 'textarea'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        temp_value = check_field(obj_type, @name, article_datas)
        if temp_value.present?
          @value = temp_value
        else
          @value = nil
        end

        respond_to do |format|
          format.html { view_string = "#{view_string} #{render_to_string('home/textarea_value', :layout => false, :locals => {:name => @name})}" }
          format.json { view_string = "#{view_string} #{render_to_string('home/textarea_value', :layout => false, :locals => {:name => @name, :value => @value}, :formats => [:html])}" }
        end
      elsif obj_type == 'checkbox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        temp_value = check_field(obj_type, @name, article_datas)
        if temp_value.present?
          @value = temp_value
        else
          @value = nil
        end

        data_type = obj_type
      elsif obj_type == 'radiobox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        temp_value = check_field(obj_type, @name, article_datas)
        if temp_value.present?
          @value = temp_value
        else
          @value = nil
        end

        data_type = obj_type
      elsif obj_type == 'select'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']

        temp_value = check_field(obj_type, @name, article_datas)
        if temp_value.present?
          @value = temp_value
        else
          @value = nil
        end

        data_type = obj_type
      elsif obj_type.include? "option"
        @data.push(x['v'])

        if i == select_format.length - 1
          view_string = "#{view_string} #{check_obj_vaule(@data, data_type, @name, @value)}"
        end
      end
    end

    return view_string
  end


  def check_field(target_type, target_name, article_datas)
    multi_same_type_data = []

    article_datas.each do |x|
      if x['t'] == target_type && x['n'] == target_name && x['t'] != 'checkbox'
        return x['v']
      elsif x['t'] == target_type && x['n'] == target_name && x['t'] == 'checkbox'
        multi_same_type_data.push(x['v'])
      end
    end

    return multi_same_type_data
  end

  def check_obj_vaule(data, data_type, name, value)
    @data = data
    @name = name
    @value = value

    view_string = nil

    if data_type == 'checkbox'
      respond_to do |format|
        format.html { view_string = render_to_string('home/checkbox_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}) }
        format.json { view_string = render_to_string('home/checkbox_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}, :formats => [:html]) }
      end
    elsif data_type == 'radiobox'
      respond_to do |format|
        format.html { view_string = render_to_string('home/radio_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}) }
        format.json { view_string = render_to_string('home/radio_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}, :formats => [:html]) }
      end
    elsif data_type == 'select'
      respond_to do |format|
        format.html { view_string = render_to_string('home/select_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}) }
        format.json { view_string = render_to_string('home/select_value', :layout => false, :locals => {:data => @data, :name => @name, :value => @value}, :formats => [:html]) }
      end
    end

    return view_string
  end


  #===================================

  #===================== Block Function =====================
  # Main Func: use category_column object_id to find one document,
  #            and render parsed embed set to partial for json type or html.

  # Floor1   : get_category_view
  #   Trigger: 新增項目，切換下拉式選單
  #   Func   : same Main Func.

  # Floor2   : get_view
  #   Trigger: internal calls
  #   Func   : use category format, to render json ,html.

  # Floor3   : check_obj
  #   Trigger: internal calls
  #   Func   : only checkbox, radio, select option, to render json ,html.

  def get_category_view
    select_category = CategoryColumn.where(:_id => params[:object_id]).first

    view_string = nil
    if select_category.present?
      view_string = get_view_category(select_category['met_options'])
    end

    render json: {:partial => view_string}
  end

  def get_view_category(default_format)
    @data = [] #option use, only radiobox, checkbox, select option,
    @name = nil #item label name

    data_type = nil
    view_string = nil #return use

    respond_to do |format|
      format.html { view_string = "#{view_string} #{render_to_string('home/title_style', :layout => false)}" }
      format.json { view_string = "#{view_string} #{render_to_string('home/title_style', :layout => false, :formats => [:html])}" }
    end

    if  default_format.blank?
      return render_to_string('home/no_category', :layout => false, :formats => [:html])
    end

    default_format.each_with_index do |x, i|
      obj_type = x['n']

      if obj_type == 'textbox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        respond_to do |format|
          format.html { view_string = "#{view_string} #{render_to_string('home/textbox_style', :layout => false, :locals => {:name => @name})}" }
          format.json { view_string = "#{view_string} #{render_to_string('home/textbox_style', :layout => false, :locals => {:name => @name}, :formats => [:html])}" }
        end
      elsif obj_type == 'textarea'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        respond_to do |format|
          format.html { view_string = "#{view_string} #{render_to_string('home/textarea_style', :layout => false, :locals => {:name => @name})}" }
          format.json { view_string = "#{view_string} #{render_to_string('home/textarea_style', :layout => false, :locals => {:name => @name}, :formats => [:html])}" }
        end
      elsif obj_type == 'checkbox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        data_type = obj_type
      elsif obj_type == 'radiobox'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        data_type = obj_type
      elsif obj_type == 'select'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        data_type = obj_type
      elsif obj_type.include? "option"
        @data.push(x['v'])

        if i == default_format.length - 1
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
        end
      end
    end

    return view_string
  end

  def check_obj(data, data_type, name)
    @data = data
    @name = name

    view_string = nil

    if data_type == 'checkbox'
      respond_to do |format|
        format.html { view_string = render_to_string('home/checkbox_style', :layout => false, :locals => {:data => @data, :name => @name}) }
        format.json { view_string = render_to_string('home/checkbox_style', :layout => false, :locals => {:data => @data, :name => @name}, :formats => [:html]) }
      end
    elsif data_type == 'radiobox'
      respond_to do |format|
        format.html { view_string = render_to_string('home/radio_style', :layout => false, :locals => {:data => @data, :name => @name}) }
        format.json { view_string = render_to_string('home/radio_style', :layout => false, :locals => {:data => @data, :name => @name}, :formats => [:html]) }
      end
    elsif data_type == 'select'
      respond_to do |format|
        format.html { view_string = render_to_string('home/select_style', :layout => false, :locals => {:data => @data, :name => @name}) }
        format.json { view_string = render_to_string('home/select_style', :layout => false, :locals => {:data => @data, :name => @name}, :formats => [:html]) }
      end
    end

    return view_string
  end
  #===================== Block Function =====================


end
