Rails.application.routes.draw do

  # ルートURLのルーティングを投稿一覧に設定
  root 'posts#index'

  # postsコントローラ内の各アクションへのルーティング
  resources :posts

  # usersコントローラ内の各アクションへのルーティング
  resources :users

  # sessionsコントローラ内の各アクションへのルーティング
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end