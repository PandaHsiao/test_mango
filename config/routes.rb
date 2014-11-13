TestMongo::Application.routes.draw do

  devise_for :users , :controllers => { :omniauth_callbacks => "omniauth_callbacks", confirmations: 'confirmations', :registrations => 'registrations', :passwords => 'passwords' }

  devise_scope :user do
    match 'registrations/register' => 'registrations#register',               :via => 'get',  :as => 'register'
    match 'registrations/register_create' => 'registrations#register_create', :via => 'post', :as => 'register_create'
    match 'registrations/account_edit' => 'registrations#account_edit',       :via => 'get',  :as => 'account_edit'

    match 'sessions/login' => 'sessions#login',                               :via => 'get',  :as => 'session_login'
    match 'sessions/create' => 'sessions#create',                             :via => 'post', :as => 'session_create'


    match 'sessions/destroy' => 'sessions#destroy',                           :via => 'get',  :as => 'session_user_destroy'


    match 'password/set_new_password' => 'passwords#set_new_password',        :via => 'get',  :as => 'set_new_password'
  end

  root :to => 'home#user_index',                           :as => 'home'

  get 'home/account_list'




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
  #root :to => 'home#index'
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

  #get 'yoolyooly/index'
  #get 'yoolyooly/signin'
  #get 'yoolyooly/signup'
  #get 'yoolyooly/signup_complete'
  #
  #get 'yoolyooly/scratch'
  #get 'yoolyooly/gift'
  #get 'yoolyooly/store_info'

end
