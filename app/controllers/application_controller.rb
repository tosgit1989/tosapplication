class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller? # deviseコントローラーのアクションが動いた時のみ、configure_permitted_parametersメソッドが働く

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:nickname) # sign_upアクション実行時にnicknameをパラメーターとして許可
  end
end
