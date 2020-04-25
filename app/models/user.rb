class User < ApplicationRecord

  # テーブル同士の相関関係を定義する方法
  # usersテーブル(Userモデル)とpostsテーブル(Postモデル)の相関関係は、
  # 1つのuser(1人の投稿者)が複数のpost(投稿)を持っているという関係になっている。
  # (ユーザー登録したユーザーは一度しか投稿できないわけではなく、何度も投稿することができるので、
  #  一人のユーザーは複数の投稿を持っているということになる)
  # このような関係を「 単 」対「 多 」の関係という。
  # (「 単 」がuserであり、「 多 」がpostに当たる)
  # このようなテーブル(モデル)同士の相関関係をコード上に定義するには、
  # 「 単 」に当たるモデル(この場合はUserモデル)内に、
  # has_many ：「 多 」に当たるテーブル名(複数形にすること)
  # と定義し、「 多 」に当たるモデル(この場合はPostモデル)に、
  #  belongs_to ：「 単 」に当たるテーブル名(単数形にすること)
  # と定義する。(belongs toは～に属するという意味)

  # テーブル同士の相関関係を定義する方法についてはScrapBookのテーブルの結合の
  # モデルの関連付け(アソシエーション)の方法も参照すること

  # postsテーブル(Postモデル)との相関関係を定義
  has_many :posts
  # usersテーブルにとってpostsテーブルは「 多 」に当たるので、
  # postという単数形ではなくpostsという複数形にすること

  # postsテーブル(Postモデル)にusersテーブル(Userモデル)との相関関係を定義する方法は、
  # app>models>post.rbファイルを参照すること


  # パスワードを暗号化
  has_secure_password

  # 各カラムにバリデーションを設定
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 4}

end
