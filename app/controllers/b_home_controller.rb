class BHomeController < ApplicationController
  def index
    @categorys = CategoryColumn.all.entries
  end

  def new_curio
    @categorys = CategoryColumn.all.entries

    default_format = nil
    if @categorys.present?
      first_category = @categorys.first
      default_format = first_category['met_options']
    end

    @categorys_option = []
    @categorys.each do |x|
      @categorys_option.push([x.name, x['_id']])
    end

    @view_string = get_view(default_format)

    begin
      respond_to do |format|
        format.html {
          @partial = render_to_string('b_home/new_curio', :layout => false)
          render :template  => 'b_home/new_curio'
        }
        format.json {
          render json: {:partial => render_to_string('b_home/new_curio', :layout => false, :locals => { :categorys => @categorys, :categorys_option => @categorys_option, :view_string => @view_string }, :formats=>[:html]) } , :status => 200
        }
      end
    rescue => e
      xxx = e.message
      xxx = 0
    end
  end

  def get_category_view
    select_category = CategoryColumn.where(:_id => params[:object_id]).first

    view_string = nil
    if select_category.present?
      view_string = get_view(select_category['met_options'])
    end

    render json:{:partial => view_string}
  end

  def get_view(default_format)
    view_string = nil
    @data = []
    data_type = nil
    @name = nil

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
          format.html { view_string = "#{view_string} #{render_to_string('b_home/textbox_style', :layout => false, :locals => { :name => @name })}" }
          format.json { view_string = "#{view_string} #{render_to_string('b_home/textbox_style', :layout => false, :locals => { :name => @name } , :formats=>[:html])}" }
        end
      elsif obj_type == 'textarea'
        if @data.present? && data_type.present?
          view_string = "#{view_string} #{check_obj(@data, data_type, @name)}"
          @data.clear
          data_type = nil
        end

        @name = x['v']
        respond_to do |format|
          format.html { view_string = "#{view_string} #{render_to_string('b_home/textarea_style', :layout => false, :locals => { :name => @name })}" }
          format.json { view_string = "#{view_string} #{render_to_string('b_home/textarea_style', :layout => false, :locals => { :name => @name }, :formats=>[:html])}" }
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
        format.html { view_string = render_to_string('b_home/checkbox_style', :layout => false, :locals => { :data => @data, :name => @name })}
        format.json { view_string = render_to_string('b_home/checkbox_style', :layout => false, :locals => { :data => @data, :name => @name }, :formats=>[:html]) }
      end

      #return render_to_string('b_home/checkbox_style', :layout => false, :locals => { :data => @data, :name => @name })
    elsif data_type == 'radiobox'
      respond_to do |format|
        format.html { view_string = render_to_string('b_home/radio_style', :layout => false, :locals => { :data => @data, :name => @name })}
        format.json { view_string = render_to_string('b_home/radio_style', :layout => false, :locals => { :data => @data, :name => @name }, :formats=>[:html]) }
      end

      #return render_to_string('b_home/radio_style', :layout => false, :locals => { :data => @data, :name => @name })
    elsif data_type == 'select'
      respond_to do |format|
        format.html { view_string = render_to_string('b_home/select_style', :layout => false, :locals => { :data => @data, :name => @name })}
        format.json { view_string = render_to_string('b_home/select_style', :layout => false, :locals => { :data => @data, :name => @name }, :formats=>[:html]) }
      end

      #return render_to_string('b_home/select_style', :layout => false, :locals => { :data => @data, :name => @name })
    end

    return view_string
  end

  def save_curio

  end
end

