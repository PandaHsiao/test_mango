class RegistrationsController < Devise::RegistrationsController
  layout 'registration'

  # GET ==== Function: show register view
  # =========================================================================
  def register
    cc = 0
  end

  # POST === Function: create user
  # =========================================================================
  def register_create
    begin
      user_create('devise/registrations/register')
    rescue => e
      Rails.logger.error APP_CONFIG['error'] + "(#{e.message})" + ",From:app/controllers/registrations_controller.rb ,Action:restaurant_create"
      flash.now[:alert] = '發生錯誤! 註冊失敗!'
      render 'devise/registrations/register'
    end
  end

  # Method === Function: validation params and save user
  # =========================================================================
  def user_create(from_url)
    name = params[:tag_name].strip
    email = params[:tag_email].strip
    phone = params[:tag_phone].strip
    password = params[:tag_password].strip

    if (name.blank? || email.blank? || phone.blank? || password.blank?)
      flash.now[:alert] = '有欄位未填喔!'
      render from_url
      return
    end

    if (email =~ /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/).blank?
      flash.now[:alert] = 'E-mail 格式錯誤!'
      render from_url
      return
    end

    user = User.where(:email => email)
    if !user.blank?
      flash.now[:alert] = '此帳號 ( E-Mail ) 已被註冊'
      render from_url
      return
    end

    person = {'name' => name,
              'email' => email,
              'phone' => phone,
              'password' => password,
              'password_confirmation' => password}
    devise_save(person)
  end

  # Method === Function: save user
  # =========================================================================
  def devise_save(person)

    User.transaction do
      build_resource(person)
      if resource.save
        yield resource if block_given?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_up(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :'signed_up_but_#{resource.inactive_message}' if is_navigational_format?
          expire_session_data_after_sign_in!
          @user_email = resource.email
          #redirect_to '/home/wait_confirm_email'
          render '/home/index', layout: 'registration'
          return
          #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        #respond_with resource
        error = resource.errors.first[1]
        flash.now[:alert] = error
        render 'devise/registrations/register'
      end

    end
  end

end
