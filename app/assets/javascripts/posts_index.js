$(function() {

    /* ajax通信を定期的に実行するためにsetIntervalメソッドを定義する
       (setIntervalメソッドについてはLeone-PCのAjax_Communicationのタイマー処理を参照すること) */
    setInterval(update, 180000);
    // コールバック関数(updateメソッド)の定義は後述


    // 投稿一覧画面の投稿テーブルに新規投稿分のレコードのみ追加するためのメソッドを定義する
    function update() {

        /* このメソッドの処理の流れは以下のような工程になる
             ①投稿テーブルのレコードの中で最後尾のレコード(最後尾のtrタグ)のdata-table_row_id属性の値を取得する
             ②ajax通信を使ってデータベースに①で取得した値(最新投稿のid番号)よりも大きい番号があったら(新規投稿があったら)、
               新規投稿分のデータを受信する
             ③②で取得したデータを使って投稿テーブルに新規投稿分のレコード(新規投稿分のtrタグ)のみ追加する */

        /* 工程①
           工程①を行うに当たって最初から投稿テーブルにレコードが無かった場合があるのでif文を使って処理を分ける */

        // 最後尾のtrタグのdata-table_row_id属性の値を格納するための変数を定義する
        let last_row_id;   // if文の中に変数を定義できないのでここで定義しておく

        // 投稿テーブルにレコードが一つでも存在する場合
        if($('.table_rows')[0]) {
        /* $('.table_rows')というjQueryオブジェクトでclass="table_rows"という属性を持つすべてのタグを取得したことになるので、
           $('.table_rows')[0]は取得したすべてのタグの中の最初のタグということになる。
           つまりこの場合は$('.table_rows')[0]は一番目の投稿に当たるので、上記の一文は一つでも投稿があったらという意味になる。
           (複数のタグを格納したjQueryオブジェクトの中から特定のタグを取得する方法にはeqメソッドもあるが、
            $('.table_rows').eq(0)としても動作しなかった)([]かget()はDOM要素を返すのに対して、eq()はjQueryオブジェクトを返すという違いらしい) */

            // 最後尾のtrタグのdata-table_row_id属性の値を取得する
            last_row_id = $('.table_rows:last').data('table_row_id');
            /* jQueryオブジェクト.data('カスタムデータ属性名') でカスタムデータ属性の値を取得することができる。
               (この場合はtable_rowsクラスを持つタグの中で、
                最後尾のタグ(一番新しい投稿のtrタグ)のカスタムデータ属性の値を取得している) */
            /* jQueryオブジェクトを取得する際のCSSセレクタに:lastを付けることで最後のタグを指定することができる */

        /* 最初から投稿テーブルにレコードが無かった場合
           (一つも投稿が無かった場合はlast_row_idに代入する値が無くなってしまうのでそのような場合は0を代入しておく) */
        } else {
            last_row_id = 0;
            /* 最初の投稿にはdata-table_row_id属性の値に1が振られるので投稿自体が無かった場合は0を代入しておく
               (postsテーブルの最初のレコードのid番号が1であるため) */
        }


        /* 工程②
           ajaxメソッドの通信先はpostsコントローラのindexアクションとなるように設定する。
           このときdataTypeをjsonとすることでindexアクションにはjsonデータをリクエストすることができる。
           (詳しい説明はpostsコントローラのindexアクションを参照すること) */
        $.ajax({

            url: "/posts",
            type: 'GET',
            dataType: 'json',
            /* 上記の3文で http://localhost:3000/posts.json にアクセス要求していることになる。
               (詳しい説明はpostsコントローラのindexアクションを参照すること) */
            data: {id: last_row_id}
            /* postsコントローラのindexアクションに送るパラメータは工程①で取得した最後尾のtrタグのid番号にすること
               (このid番号を元にpostsコントローラのindexアクションで新規投稿があったかをデータベースに検索するということになる)
               (詳しい説明はpostsコントローラのindexアクションを参照すること) */

        // 通信成功時の処理
        }).done(function(data) {

            console.log(data);  // 取得したデータを確認するためにログを出力する

            /* dataに値がない場合(新規投稿がない場合)があるので、
               dataに値がある場合(新規投稿がある場合)のみ新規投稿分のレコードの追加処理を行うように
               if文を使って処理を分ける */

            // dataに値がある場合の処理
            if(data.length) {
            // data.lengthでdataに値が入っているかどうかの確認ができる模様

                /* 工程③
                   ajax通信で取得したデータを使って投稿テーブルに新規投稿分のレコードのみ追加する */
                for(let new_post_data of data) {
                    // jbuilderから送られてくるデータはJSONデータが配列に格納された状態なのでfor-of文で1つ1つ取り出して処理する

                    // 投稿テーブルに新規投稿分のレコードのみ追加する
                    addTableRow(new_post_data);
                    // addTableRowメソッドの定義は後述
                }

            }
            // dataに値が入っていない場合は何もしない

        // 通信失敗時の処理
        }).fail(function() {
            alert("自動更新に失敗しました");
        });

    }


    // 投稿一覧画面の投稿テーブルに新規投稿分の一行を追加するためのメソッドを定義する
    function addTableRow(post_data) {
    // 引数のpost_dataには新規投稿のJSONデータ(ajaxメソッド内のfor文内のnew_post_data)の一つが渡される

        // 投稿テーブルのtbodyタグ内に追加するtrタグ(新規投稿分の一行)を作成する
        let addTrTag = `<tr class="table_rows" data-table_row_id="${post_data.id}">
                        <!-- data-table_row_id属性の値にダブルクォーテーションを付ける理由はWaterfoxのScrapBookを参照すること -->
                          <td class="text-center">${post_data.name}</td>
                          <td>
                            ${post_data.speech}
                            <a href="/posts/${post_data.id}" class="float-right">詳細</a>
                            <!-- Railsのlink_toメソッドを記述すると文字列として認識されてしまうのでaタグにして記述すること -->
                          </td>
                        </tr>`;
        /* JavaScriptの変数展開においては改行やスペースは認識されるが、
           HTMLでは改行やスペースは無視されるのでこのような書き方ができる。
           (HTMLではタグとタグの間にどれだけ改行やスペースがあろうと何もないという扱いになる)
           (JavaScriptの変数展開についてはJavaScript_Basicの変数の扱い方.jsを参照すること) */

        // 上記で作成したaddTrTagを投稿テーブルのtbodyタグ内に追加する
        $('#table_body').append(addTrTag);
        /* ここでtbodyタグを指定してaddTrTagを追加すると、
           showビューのtbodyタグ内にまでaddTrTagが追加されてしまう。(原因は不明)
           これを回避するためにindexビューのtbodyタグにid属性を追加する。
           (このid属性の値を指定することでindexビューのtbodyタグのみを指定できるようになる) */
    }

});