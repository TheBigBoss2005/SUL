$(function() {
  // lock individually form when page loaded
  $("[id^=payment_price]").prop('disabled', true);

  // lock/unlock individually form
  $("#source_user_ids").change(function() {
    $("[id^=payment_price]").prop('disabled', true);
    $("#source_user_ids :selected").each(function() {
      $("#payment_price_"+$(this).val()).prop('disabled', false);
    });
  });

  // autoinput individually form
  $("#item_price").change(function() {
    if ($(this).val() != "") {
      var price = parseInt($(this).val());
      var per = $("#source_user_ids :selected").length;
      if (per != 0 && price != 0) {
        var individually = parseInt(price / per);
        $("#source_user_ids :selected").each(function() {
          $("#payment_price_"+$(this).val()).val(individually);
        });
        $("#total").text(getTotal());
      };
    };
  });

  // sum individually form values
  $("[id^=payment_price]").change(function() {
    $("#total").text(getTotal());
  });

  // get total
  function getTotal() {
    var total = 0;
    $("[id^=payment_price]").each(function() {
      var num = $(this).val();
      total = num != "" ? total + parseInt(num) : total;
    });
    return total;
  };
});

