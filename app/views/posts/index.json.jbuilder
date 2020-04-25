# 新規投稿分のデータをJSON形式にしてajaxメソッドのdoneメソッドに返す処理
if @new_posts.present?
  json.array! @new_posts
end