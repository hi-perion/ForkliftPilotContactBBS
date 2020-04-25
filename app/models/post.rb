class Post < ApplicationRecord

  # Userモデルとの関連付け
  belongs_to :user

  # モデルとアップローダの関連付け
  mount_uploader :image, ImageUploader
  
  # 各カラムにバリデーションを設定
  validates :pilot, presence: true
  validates :machine, presence: true
  validates :affiliation, presence: true
  validates :series, presence: true
  validates :speech, presence: true, length: {maximum: 100}

end