class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from User::Exception, :with => :show_error

  ## override devise
  def after_sign_in_path_for_custom(resource_or_scope, res_url)
    session.delete :res_url
    stored_location_for(resource_or_scope) || sign_in_with_custom(resource_or_scope, res_url)
  end

  def sign_in_with_custom(user, res_url)
    begin

      if user.present?

      end
      home_path
    rescue => e
      Rails.logger.error APP_CONFIG['error'] + "(#{e.message})" + ",From:app/controllers/application_controller.rb  ,Method:sign_in_with_custom(user, res_url)"
      home_path
    end
  end

  def show_error(exception)
    begin
      self.resource = resource_class.new
      clean_up_passwords(resource)

      if !current_user.blank?
        flash.now[:alert] = '發生未知的錯誤！為保安全，我們將您登入狀態清除，請再次登入，謝謝'
        render 'devise/sessions/login'
        return
      else
        redirect_to home_path
      end
    rescue => e
      flash.now[:alert] = '發生未知的錯誤，請聯絡公司開發人員，謝謝'
      redirect_to home_path
    end
  end
end
