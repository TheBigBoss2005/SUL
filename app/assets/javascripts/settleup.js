$(function() {
  $(document).on("ready page:load", function() {
    // disable settleup button when page loaded
    $("#settleup").prop('disabled', true);

    // init footable
    $(".footable").footable();

    // enable/disable settleup button
    function toggle_settleup_button() {
      if ($("[name='payment_ids[]']:checked").length > 0) {
        $("#settleup").removeAttr('disabled');
      } else {
        $("#settleup").prop('disabled', true);
      }
    };

    // toggle checkbox when checkbox clicked
    $(":checkbox[name='payment_ids[]']").click(function() {
      if ( $(this).prop('checked') ) {
        $(this).prop('checked', '');
      } else {
        $(this).prop('checked', 'checked');
      }
      toggle_settleup_button();
    });

    // toggle checkbox when table row clicked
    $("table tr").click(function() {
      var checkbox = $(this).children("td").children(":checkbox");
      if ( checkbox.prop('checked') ) {
        checkbox.prop('checked', '');
      } else {
        checkbox.prop('checked', 'checked');
      }
      toggle_settleup_button();
    });
  });
});
