# jbuilderとはコントローラのアクション内で定義されたインスタンス変数のデータを
# JSONデータに変換してJSONリクエストに返す処理をするためのファイルである(ビュー扱いになっている模様)
# (jbuilderファイル内でインスタンス変数を使用せず直接値を記述することもできる)

# jbuilderファイルを作成する際はコントローラに対応するビューフォルダ内に
# アクション名.json.jbuilder と命名すること

# jbuilderでは「 json 」というjbuilderオブジェクトを利用してJSONデータを作成していく。
# 例：json.name "アムロ" で {"name": "アムロ"} というJSONデータを出力することができる。
# (jbuilderオブジェクトの詳しい使い方はScrapBookのjbuilderの使い方を参照すること)


# このファイル(index.json.jbuilderファイル)には、
# postsコントローラのindexアクションのrespond_toメソッドのformat.jsonの処理内で定義した、
# ＠new_postsというインスタンス変数が渡されてくる
# (＠new_postsには新規投稿のレコードが配列の形で格納されている)


# 新規投稿分のJSONデータをajaxメソッドのdoneメソッド(JSONリクエスト)に返す処理

# 定期的にajax通信が実行されて、渡されてくる＠new_postsには中身がない(新規投稿がない)場合もあるので、
# if文によって処理を分ける

# 新規投稿があった場合の処理
if @new_posts.present?
# present?メソッドで対象となるオブジェクト(インスタンス変数)の中身の存在確認をすることができる
# (詳しい説明はScrapBookのRuby(Rails)独特の表記方法のnil?、empty?、blank?、present?についてを参照すること)

  # ＠new_posts内に格納されているすべてのレコードをJSON形式に変換して
  # 配列の形でajaxメソッドのdoneメソッド(JSONリクエスト)に返す
  json.array! @new_posts
  # array!メソッドの詳しい説明はScrapBookのjbuilderの使い方を参照すること

  # 正確には puts json.array! ＠new_posts である模様(putsでなくreturnにすると通信失敗になる)
  # (値をputsでJSONリクエストに出力するという意味である模様)

end
# 新規投稿が無かった場合は何も書かなくていいようだが、何も書かないことで空配列やnilが返っているのか、
# 通信自体は成功扱いにして何も返さない(空配列もnilも返さない)でいるのかは不明。
# (ブラウザのコンソールで確認すると「 {} 」となっているので何かしらの空データが返っている模様)