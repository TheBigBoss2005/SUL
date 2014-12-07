$(function() {
  // lock individually form when page loaded
  $("[id^=payment_price]").prop('disabled', true);

  // lock/unlock individually form
  $("[id=source_user_ids]").change(function() {
    $("[id^=payment_price]").prop('disabled', true);
    $("[id=source_user_ids] :selected").each(function() {
      $("[id=payment_price_"+$(this).val()+"]").prop('disabled', false);
    });
  });
});

