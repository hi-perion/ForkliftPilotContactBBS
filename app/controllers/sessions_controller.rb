class SessionsController < ApplicationController

  # ログインしていた場合に掲示板の一覧画面に戻すための処理
  before_action :forbid_login, {only: [:new, :create]}


  # ログイン画面
  def new
  end

  # ログイン処理
  def create
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to posts_path, flash: {success: "ログインしました"}
    else
      flash.now[:failure] = "メールアドレスまたはパスワードが間違っています"
      @email = session_params[:email]
      @password = session_params[:password]
      render :new
    end
  end

  # ログアウト処理
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "ログアウトしました"
  end


  # ここ以下のメソッドは外部アクセス禁止
  private

    # ストロングパラメータ
    def session_params
      params.require(:session).permit(:email, :password)
    end

end
