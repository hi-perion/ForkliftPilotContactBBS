class UsersController < ApplicationController

  # ログインしていなかった場合にログイン画面に戻すための処理
  before_action :require_login, {only: [:show, :edit, :update, :destroy]}

  # ログインしていた場合に掲示板の一覧画面に戻すための処理
  before_action :forbid_login, {only: [:new, :create]}

  # 別のユーザーの固有ページにアクセスしようとした場合に掲示板の一覧画面に戻すための処理
  before_action :require_admin, {only: [:show, :edit, :update]}

  # ユーザー一覧画面の閲覧を禁止するための処理
  # (ユーザー一覧画面は下記をコメントアウトしたときに制作者のみが閲覧できるようにしている)
  before_action :access_ban, {only: [:index]}

  # 指定したアクションにインスタンス変数を定義
  before_action :set_user, {only: [:show, :edit, :update, :destroy]}


  # 一覧画面
  def index
    @users = User.all
  end

  # 詳細画面
  def show
  end

  # 新規登録画面
  def new
    @user = User.new
  end

  # 新規登録処理
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to posts_path, flash: {success: "登録しました"}
    else
      flash.now[:failure] = "入力していない項目があります"
      render :new
    end
  end

  # 編集画面
  def edit
  end

  # 更新処理
  def update
    if @user.update(user_params)
      redirect_to posts_path, flash: {success: "編集しました"}
    else
      flash.now[:failure] = "入力していない項目があります"
      render :edit
    end
  end

  # 削除処理
  def destroy
    @user.destroy
    redirect_to posts_path, alert: "退会しました"
  end


  # ここ以下のメソッドは外部アクセス禁止
  private

    # インスタンス変数の定義をメソッド化
    def set_user
      @user = User.find_by(id: params[:id])
    end

    # 掲示板の一覧画面に戻す処理(別のユーザーの固有ページにアクセスしようとしたときのため)
    def require_admin    # admin(アドミン)(administratorの省略形)：管理者
      if @current_user.id != params[:id].to_i
        redirect_to posts_path, alert: "権限がありません"
      end
    end

    # 無条件で掲示板の一覧画面に戻す処理(ユーザー一覧画面をにアクセスしようとしたときのため)
    def access_ban
      redirect_to posts_path, alert: "権限がありません"
    end

    # ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end