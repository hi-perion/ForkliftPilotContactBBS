class PostsController < ApplicationController

  # ログインしていなかった場合にログイン画面に戻すための処理
  before_action :require_login, {only: [:new, :create, :edit, :update, :destroy]}

  # 別のユーザーの投稿を編集、削除しようとした場合に掲示板の一覧画面に戻すための処理
  before_action :require_admin, {only: [:edit, :update, :destroy]}

  # 指定したアクションにインスタンス変数を定義
  before_action :set_post, {only: [:show, :edit, :update, :destroy]}


  # 一覧画面
  def index

    # ルーティングに「 get 'posts' 」として要求されるリクエストには、
    # 一覧画面(indexビュー)を表示させるためのアクセス要求(HTMLリクエスト)である
    # ｈttp://localhost:3000/posts.html (リクエストフォーマットがHTMLの場合は「 .html 」は省略可能)と、
    # ajax通信がJSONデータを要求するためのアクセス要求(JSONリクエスト)である
    # ｈttp://localhost:3000/posts.json (正確には末尾にパラメータも付与されている)の2種類がある。
    # このような場合はrespond_toメソッドを使用してリクエストフォーマットごとに処理を分ける必要がある。

    # respond_toメソッドの使い方
    # respond_to do |format|
    #   format.html{リクエストフォーマットがHTMLの場合に実行する処理}
    #   format.json{リクエストフォーマットがJSONの場合に実行する処理}
    #   format.xml{リクエストフォーマットがXMLの場合に実行する処理}
    #   ・・・
    # end
    # でリクエストフォーマットごとに処理を分けることができる。
    # このときformat.htmlの処理を行った場合はapp>views>posts>index.erbファイルが呼び出され、
    # format.jsonの処理を行った場合はapp>views>posts>index.json.jbuilderファイルが呼び出される。
    # (jbuilderファイルはJSONデータをブラウザに返すための処理をするファイルである)
    # (詳しい説明はapp>views>posts>index.json.jbuilderファイルを参照すること)


    # respond_toメソッド内で使用する変数を定義する
    @posts = Post.all
    # ＠postsはリクエストフォーマットがHTMLでもJSONでも使用するのでrespond_toメソッドの外に定義しておく必要がある


    # リクエストフォーマットがHTMLの場合とJSONの場合とで処理を分ける
    respond_to do |format|


      # HTML形式でのリクエストがあった場合の処理
      format.html
      # index.erbビュー内で＠postsという変数を使用するが、＠postsはrespond_toメソッドの外に既に定義してあるので、
      # この場合は何も記述する必要はない。(「 format.html {＠posts = Post.all} 」とは書かなくていい)
      # この処理の後にapp>views>posts>index.erbファイルが呼び出されるという流れになる。


      # JSON形式でのリクエストがあった場合の処理
      # (処理が複数行になる場合は
      #  format.リクエスト形式 do
      #    処理
      #  end
      #  としてもいい模様)
      format.json do

        # JSONリクエスト(この場合はajaxメソッドのdoneメソッド)に返したいデータは、
        # postsテーブルの新規投稿分のレコードのidカラムの値とspeechカラムの値、
        # およびそれに付随するusersテーブルのusers.nameカラムの値だが、
        # これらのデータはテーブルが違うので一度に取得することができない。
        # そこでpostsテーブルのuser_idカラムの値とusersテーブルのidカラムの値を紐付けて、
        # 一つのテーブルを作成する(2つのテーブルを結合する)必要がある。

        # ActiveRecord文を使用してテーブルの結合を行うには、
        # 各テーブル(モデル)にテーブル同士の相関関係を定義しておく必要がある。
        # (詳しい説明はapp>models>user.rbおよびapp>models>post.rbファイルを参照すること)

        # テーブルを結合する方法
        # モデル名.joins(：テーブル名)
        # でテーブル同士を結合することができる(テーブル同士はあらかじめ相関関係を定義しておくこと)
        # (結合する側のテーブル(この場合はpostテーブル)に「 結合される側のテーブル名(単数形)_id 」というカラムを作成して、
        #  結合する側のidと値を合わせておくこと)(このid番号を基準にして2つのテーブルを結合するということになる)
        # (joinsメソッドの詳しい説明はScrapBookのテーブルの結合を参照すること)
        # (N+1問題対策のためにjoinsメソッドの代わりにincludesメソッドを使うとselectメソッドが使用できなくなる)(理由は不明)
        @new_posts = Post.joins(:user).select("posts.id, posts.speech, users.name").where('posts.id > ?', params[:id])
        # joinsメソッドの引数である「 ：user 」はPostモデルのbelongs_toで指定した「 ：user 」のことである。
        # (postsテーブルにとってのusersテーブルが「 単 」に当たるので単数形になっていることに注意すること)
        # joinsメソッドで結合してもselectメソッドで取得カラムを指定しないとpostsテーブルのカラムしか取得できないので注意すること

        # whereメソッドで使用している「 ? 」はプレースホルダーなので、「 ? 」にはparams[：id]の値が代入されるということになる
        # (プレースホルダーの詳しい説明はScrapBookのActiveRecordの基本文法を参照すること)

        # ActiveRecord文の実行結果を確認する方法はapp>views>about_rails_console.erbファイルを参照すること

        # 上記の一文でparams[：id]よりも大きいid番号を持つレコード(新規投稿分のレコード)のみ抽出して
        # 配列の形にして＠new_postsに代入している
        # (whereメソッドの条件に該当しない場合はnilが返っている模様)

      end
      # この処理の後にapp>views>posts>index.json.jbuilderファイルが呼び出され、
      # その中で上記の＠new_postsというインスタンス変数を使用するという流れになる。
      # (詳しい説明はapp>views>posts>index.json.jbuilderファイルを参照すること)

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
      flash.now[:failure] = "入力していない項目があります"    # failure(フェイリヤー)：失敗
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