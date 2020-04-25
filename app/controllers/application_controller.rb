class ApplicationController < ActionController::Base

  # すべてのアクションにログインユーザーを定義
  before_action :set_current_user


  # ここ以下のメソッドは外部アクセス禁止
  private

    # ログインユーザーの定義をメソッド化
    def set_current_user
      @current_user = User.find_by(id: session[:user_id])
    end

    # ログインしていなかった場合にログイン画面に戻すためのメソッド
    def require_login     # require(リクワイア)：～を必要とする
      if @current_user == nil
        redirect_to login_path, alert: "ログインが必要です"
      end
    end

    # ログインしていた場合に掲示板の一覧画面に戻すためのメソッド
    def forbid_login    # forbid(フォービッド)：～を禁止する
      if @current_user
        redirect_to posts_path, notice: "すでにログインしています"
      end
    end

end