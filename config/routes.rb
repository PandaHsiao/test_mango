TestMongo::Application.routes.draw do

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



  scope :format => true, :constraints => { :format => 'json' } do
    get  'home/index'
    get  'home/new_category'
    post 'home/save_category'
    post 'home/get_category_view'      #jquery partial view


    get  'home/curio_list'
    get  'home/new_curio'
    post 'home/save_curio'
    post 'home/query_curio_by_filter'

    post 'home/get_curios_view'        #jquery partial view

    post 'home/get_article_view'       #jquery partial view


  end

  get 'home/test'


  #= Abandoned =================================
  #get  'home/category_list'      # replace by home/index partial view

  #= DataBase===================================
  get  'home/clear_db'

  #= Test ======================================
  get  'home/test_category'

  #= Home ======================================
  root :to => 'home#index'
  get  'home/index'

  get  'home/new_category'
  post 'home/save_category'
  get  'home/modify_category'
  get  'home/delete_category'


  get  'home/curio_list'
  get  'home/new_curio'
  post 'home/save_curio'

  #= B_home =====================================
  get  'b_home/index'

  #= Main =======================================
  get 'main/index'



  #======================================

  get 'yoolyooly/index'
  get 'yoolyooly/signin'
  get 'yoolyooly/signup'
  get 'yoolyooly/signup_complete'

  get 'yoolyooly/scratch'
  get 'yoolyooly/gift'
  get 'yoolyooly/store_info'

end
