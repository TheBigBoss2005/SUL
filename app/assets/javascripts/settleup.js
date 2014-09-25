$(function() {
  // disable settleup button when page loaded
  $("#settleup").prop('disabled', true);

  // enable/disable settleup button when checkbox clicked
  $(":checkbox").click(function() {
    if ($("[name='payment_ids[]']:checked").length > 0) {
      $("#settleup").removeAttr('disabled');
    } else {
      $("#settleup").prop('disabled', true);
    }
  });
});

