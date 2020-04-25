class User < ApplicationRecord

  # Postモデルとの関連付け
  has_many :posts

  # パスワードを暗号化
  has_secure_password

  # 各カラムにバリデーションを設定
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 4}

end
