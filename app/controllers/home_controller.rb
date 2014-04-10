class HomeController < ApplicationController
  layout 'home'

  def index
    @categorys = CategoryColumn.all.entries
    respond_to do |format|
      format.html {
        @partial = render_to_string('home/category_list', :layout => false)
        render :template  => 'home/index'
      }
      format.json {
        render json: {:partial => render_to_string('home/category_list', :layout => false,:locals => { :categorys => @categorys }, :formats=>[:html]) } , :status => 200
      }
    end
  end

  def test_category
    #(1..10).each do |x|
    #  c = Category.new
    #  c.name = 'Paintings'
    #  fs = []
    #  (1..10).each do |y|
    #    fs.push(Met.new(:n => y, :v => rand(0..1000)))
    #  end
    #
    #  c.mets = fs
    #  c.save
    #end

    #xx = Category.where('mets.n' => '1').('mets.v' => '800').count
    #xx = Category.where(mets: {'$elemMatch' => {v: '800',n: '1'}})

    xx = Category.query_special_field('1','800').all.entries


    xx = 0
  end

  def delete_category
    xx = CategoryColumn.all.entries
    xx.each do |c|
      c.destroy
    end

  end

  def create_category

    respond_to do |format|
      format.html {
        @partial = render_to_string('home/create_category', :layout => false)
        render :template  => 'home/index'
      }
      format.json {
        render json: {:partial => render_to_string('home/create_category', :layout => false, :formats=>[:html]) } , :status => 200
      }
    end

    #render json: {:partial => render_to_string('home/create_category', :layout => false)}
  end

  def save_category
    category_data = params[:category_data]

    category_column = CategoryColumn.new
    met_options = []

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
          category_column.status = '0'    # 0 disable, 1 enable
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

    category_column.met_options = met_options
    category_column.save

    #cccc = CategoryColumn.where(:name => 'test1').first
    #
    #xx = 0

  end

  def category_list
    @categorys = CategoryColumn.all.entries
    xxx = 0
  end

  def modify_category

  end




end
