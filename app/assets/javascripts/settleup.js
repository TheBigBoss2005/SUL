$(function() {
  $(document).on("ready page:load", function() {
    // disable settleup button when page loaded
    $("#settleup").prop('disabled', true);

    // init footable
    $(".footable").footable();
    var $footable = $('.footable').data('footable');

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
      if ( $(document).width() <= 480 ) {
        $footable.toggleDetail($(this).parents('td:first').parents('tr:first'));
      }
    });

    // toggle checkbox when status cell clicked
    $("td:nth-child(6)").click(function() {
      var checkbox = $(this).children(":checkbox");
      if ( checkbox.prop('checked') ) {
        checkbox.prop('checked', '');
      } else {
        checkbox.prop('checked', 'checked');
      }
      toggle_settleup_button();
      if ( $(document).width() <= 480 ) {
        $footable.toggleDetail($(this).parents('tr:first'));
      }
    });
  });
});
