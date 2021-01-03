class PostsController < ApplicationController

  # ログインしていなかった場合にログイン画面に戻すための処理
  before_action :require_login, {only: [:new, :create, :edit, :update, :destroy]}

  # 別のユーザーの投稿を編集、削除しようとした場合に掲示板の一覧画面に戻すための処理
  before_action :require_admin, {only: [:edit, :update, :destroy]}

  # 指定したアクションにインスタンス変数を定義
  before_action :set_post, {only: [:show, :edit, :update, :destroy]}


  # 一覧画面
  def index
    @posts = Post.all
    respond_to do |format|
      format.html
      format.json do
        @new_posts = Post.joins(:user).select("posts.id, posts.speech, users.name").where('posts.id > ?', params[:id])
      end
    end
  end

  # 詳細画面
  def show
    unless @post
      redirect_to posts_path, notice: "投稿が存在しません"
    end
  end

  # 新規投稿画面
  def new
    @post = Post.new
  end

  # 新規投稿処理
  def create
    @post = Post.new(post_params.merge(user_id: @current_user.id))
    if @post.save
      redirect_to posts_path, flash: {success: "投稿しました"}
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
    if @post.update(post_params)
      redirect_to posts_path, flash: {success: "編集しました"}
    else
      flash.now[:failure] = "入力していない項目があります"
      render :edit
    end
  end

  # 削除処理
  def destroy
    @post.destroy
    redirect_to posts_path, alert: "削除しました"
  end


  # ここ以下のメソッドは外部アクセス禁止
  private

    # インスタンス変数の定義をメソッド化
    def set_post
      @post = Post.find_by(id: params[:id])
    end

    # 掲示板の一覧画面に戻す処理(別のユーザーの投稿を編集、削除しようとしたときのため)
    def require_admin
      @post = Post.find_by(id: params[:id])
      if @post
        if @post.user_id != @current_user.id
          redirect_to posts_path, alert: "権限がありません"
        end
      else
        redirect_to posts_path, alert: "投稿が存在しません"
      end
    end

    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:pilot, :machine, :affiliation, :series, :speech, :image, :remove_image)
    end

end