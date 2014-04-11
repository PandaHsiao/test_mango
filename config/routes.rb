TestMongo::Application.routes.draw do

  get "b_home/index"
  devise_for :users

  #devise_for :users , :controllers => { :omniauth_callbacks => "omniauth_callbacks", confirmations: 'confirmations', :registrations => 'registrations', :passwords => 'passwords' }
  #
  #devise_scope :user do
  #  match 'registrations/restaurant_new' => 'registrations#restaurant_new',      :via => 'get',    :as => 'res_new'
  #  match 'registrations/restaurant_create' => 'registrations#restaurant_create',:via => 'post',   :as => 'res_create'
  #  match 'registrations/booker_new' => 'registrations#booker_new',              :via => 'get',    :as => 'booker_new'
  #  match 'registrations/booker_create' => 'registrations#booker_create',        :via => 'post',   :as => 'booker_create'
  #  match 'registrations/account_edit' => 'registrations#account_edit',          :via => 'get',    :as => 'account_edit'
  #
  #  match 'sessions/restaurant_new' => 'sessions#restaurant_new',                :via => 'get',    :as => 'res_session_new'
  #  match 'sessions/booker_new' => 'sessions#booker_new',                        :via => 'get',    :as => 'booker_session_new'
  #  match 'sessions/create' => 'sessions#create',                                :via => 'post',   :as => 'login_session'
  #  match 'sessions/destroy' => 'sessions#destroy',                              :via => 'delete', :as => 'destroy_u_session'
  #  match 'sessions/guest_login_check' => 'sessions#guest_login_check',          :via => 'get',    :as => 'guest_login_check'
  #
  #  match 'password/set_new_password' => 'passwords#set_new_password',           :via => 'get',    :as => 'set_new_password'
  #  match 'confirmation/resend_confirm_email' => 'confirmations#resend_confirm_email', :via => 'get',    :as => 'resend_confirm_email'
  #
  #  match '/users/auth/:provider' => 'omniauth_callbacks#passthru' ,             :via => 'get'
  #
  #  get   'restaurant' => 'restaurant_manage#restaurant', :as => 'confirmation_getting_started'
  #
  #end

  root :to => 'home#index'



  scope :format => true, :constraints => { :format => 'json' } do
    get  'home/index'
    get  'home/create_category'
    get  'b_home/new_curio'
  end

  get  'home/index'
  get  'home/test_category'
  get  'home/create_category'


  get  'home/category_list'

  post 'home/save_category'
  get  'home/modify_category'

  get  'home/delete_category'

  #==============================================================
  get  'b_home/index'
  get  'b_home/new_curio'
  post 'b_home/get_category_view'

end