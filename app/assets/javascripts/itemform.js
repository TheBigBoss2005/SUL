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

  // sum individually form values
  $("[id^=payment_price]").change(function() {
    var total = 0;
    $("[id^=payment_price]").each(function() {
      var num = $(this).val();
      total = num != "" ? total + parseInt(num) : total;
    });
    $("#total").text(total);
  });
});

