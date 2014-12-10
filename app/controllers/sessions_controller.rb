class SessionsController < Devise::SessionsController
  layout 'registration'

  def login
    begin
      if current_user.present?
        redirect_to home_path
      else
        self.resource = resource_class.new
        clean_up_passwords(resource)
        respond_with(resource, serialize_options(resource))
      end
    rescue => e
      xx = 0
    end
  end

  # POST /resource/sign_in
  def create
    user = params[:user]

    begin
      target_user = User.where(:email => user[:email])

      if target_user.blank?
        flash.now[:alert] = '沒有此E-Mail 資料!'
        self.resource = resource_class.new
        render 'devise/sessions/login'
        return
      end
    rescue => e
      Rails.logger.error APP_CONFIG['error'] + "(#{e.message})" + ",From:app/controllers/sessions_controller.rb  ,Action:create"
      redirect_to home_path
      return
    end

    begin
      if target_user.first.confirmation_token.length != 20
        if user[:role] == '0'
          flash.now[:alert] = '信箱尚未驗證!!'
          self.resource = resource_class.new
          render 'devise/sessions/restaurant_new'
        elsif user[:role] == '1'
          flash.now[:alert] = '信箱尚未驗證!!'
          self.resource = resource_class.new
          render 'devise/sessions/booker_new'
        end
        return
      end

      self.resource = warden.authenticate(auth_options)  #warden.authenticate!(auth_options)

      if self.resource.blank?
        flash.now[:alert] = '密碼錯誤!'
        self.resource = resource_class.new
        clean_up_passwords(resource)
        respond_with(resource, serialize_options(resource))

        render 'devise/sessions/login'

        return
      end

      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to after_sign_in_path_for_custom(resource, nil)
        #respond_with resource, :location => after_sign_in_path_for(resource)

    rescue => e
      Rails.logger.error APP_CONFIG['error'] + "(#{e.message})" + ",From:app/controllers/sessions_controller.rb  ,Action:create"
      redirect_to home_path
      return
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))

    respond_to do |format|
      format.json { render :json => {:sign_out => true } }
      format.html { redirect_to :back}
    end
  end


end
