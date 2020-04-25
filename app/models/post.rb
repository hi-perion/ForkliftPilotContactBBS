class Post < ApplicationRecord

  # usersテーブル(Userモデル)との相関関係を定義
  # (テーブル同士の相関関係を定義する方法はapp>models>user.rbファイルを参照すること)
  belongs_to :user    # belongs toは～に属するという意味
  # postsテーブルにとってusersテーブルは「 単 」に当たるので、
  # usersという複数形ではなくuserという単数形にすること

  # 上記でテーブル同士の相関関係を定義したことで、
  # 投稿(postsテーブルのレコードが代入された＠post)に紐付くユーザーのインスタンス(usersテーブルのレコード)を
  # ＠post.user で取得できるようになる。
  # したがって下記で定義している「投稿したユーザーのインスタンスを取得するメソッド」は不要となる

  # テーブル同士の相関関係を定義したので下記のメソッドは不要になる
  # def user
  #   User.find_by(id: self.user_id)    # returnは省略
  # end
  # このメソッドの使用箇所は投稿一覧画面の投稿テーブルの投稿者名を表示させる部分なので修正しておくこと
  # (詳しい説明はapp>views>posts>index.erbビューを参照すること)


  # モデルとアップローダの関連付け
  mount_uploader :image, ImageUploader
  
  # 各カラムにバリデーションを設定
  validates :pilot, presence: true
  validates :machine, presence: true
  validates :affiliation, presence: true
  validates :series, presence: true
  validates :speech, presence: true, length: {maximum: 100}

end