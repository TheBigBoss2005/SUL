$(function() {
  // 支払金額合計値を算出する関数
  function getTotal() {
    var total = 0;
    $("[id^=payment_price]").each(function() {
      var num = $(this).val();
      total = num != "" ? total + parseInt(num) : total;
    });
    return total;
  };

  // 全角数字を半角数字に変換する関数
  function zen2han(str){
    return str.replace(/[０-９]/g,function($0){
      return String.fromCharCode(parseInt($0.charCodeAt(0))-65248);
    });
  };

  // ページロード時に個々の支払金額入力欄を入力不可にしておく(誤入力防止)
  $("[id^=payment_price]").prop('disabled', true);

  // 個々の支払金額入力欄の入力可否を切り替える
  $("#source_user_ids").change(function() {
    // いったんすべて入力不可にする
    $("[id^=payment_price]").prop('disabled', true);
    // 支払元で選択した参加者に対応する入力欄だけ入力可にする
    $("#source_user_ids :selected").each(function() {
      $("#payment_price_"+$(this).val()).prop('disabled', false);
    });
  });

  // 合計金額入力時に個々の支払金額入力欄に割り勘金額を自動入力する
  $("#item_price").change(function() {
    if ($(this).val() != "") {
      // 全角数字での入力に備え、半角数字化しておく
      var price = parseInt(zen2han($(this).val()));
      $(this).val(price);
      // 支払元の人数カウント
      var per = $("#source_user_ids :selected").length;

      if (per != 0 && price != 0) {
        // 割り勘金額を算出して入力する
        var individually = parseInt(price / per);
        $("#source_user_ids :selected").each(function() {
          $("#payment_price_"+$(this).val()).val(individually);
        });
        // 合計値を算出して表示する
        $("#total").text(getTotal());
      };
    };
  });

  // 個々の支払金額更新時に合計値を画面に表示する
  $("[id^=payment_price]").change(function() {
    // 全角数字での入力に備え、半角数字化しておく
    $(this).val(parseInt(zen2han($(this).val())));
    // 合計値を算出して表示する
    $("#total").text(getTotal());
  });

  // 確定ボタン押下時に入力内容等のチェックを行う
  $("#new_item").submit(function() {
    var message_array = new Array;
    // 必須入力項目のチェック
    if ($("#source_user_ids :selected").length == 0) message_array.push("支払元を選択して下さい");
    if ($("#item_memo").val() == "") message_array.push("品目を入力して下さい");
    if ($("#item_price").val() == "") message_array.push("合計金額を入力して下さい");
    if (getTotal() == 0) message_array.push("個々の金額を入力して下さい");

    if (message_array.length > 0) {
      // エラーメッセージ出力
      alert(message_array);
    } else {
      if ($("#item_price").val() == getTotal() || confirm("金額欄に入力した値と個々の支払金額の合計値が一致しませんがよろしいですか？")) {
        // フォーム送信
        $(this).off('submit');
        $(this).submit();
      };
    };
    return false;
  });
});

