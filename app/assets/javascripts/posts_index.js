$(function() {

    // ajax通信を定期的に実行するためにsetIntervalメソッドを定義
    setInterval(update, 180000);

    // 投稿一覧画面の投稿テーブルに新規投稿分のレコードのみ追加するためのメソッドを定義
    function update() {
        let last_row_id;
        if($('.table_rows')[0]) {
            last_row_id = $('.table_rows:last').data('table_row_id');
        } else {
            last_row_id = 0;
        }
        $.ajax({
            url: "/posts",
            type: 'GET',
            dataType: 'json',
            data: {id: last_row_id}
        }).done(function(data) {
            if(data.length) {
                for(let new_post_data of data) {
                    addTableRow(new_post_data);
                }
            }
        }).fail(function() {
            alert("自動更新に失敗しました");
        });
    }

    // 投稿一覧画面の投稿テーブルに新規投稿分の一行を追加するためのメソッドを定義
    function addTableRow(post_data) {
        let addTrTag = `<tr class="table_rows" data-table_row_id="${post_data.id}">
                          <td class="text-center">${post_data.name}</td>
                          <td>
                            ${post_data.speech}
                            <a href="/posts/${post_data.id}" class="float-right">詳細</a>
                          </td>
                        </tr>`;
        $('#table_body').append(addTrTag);
    }

});