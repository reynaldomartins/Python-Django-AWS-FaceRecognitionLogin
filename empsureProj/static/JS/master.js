jQuery(document).ready(function($) {

        $(".download-doc").click(function(e) {
            e.stopPropagation();
        });

        $(".delete-doc-icon").click(function(e) {
            // var docref = $(this).parent().find('.doc-ref').first();
            var docref = $(this).parent().parent().children('#doc-ref');
            var docname = $(this).parent().parent().children('#doc-name').text();
            $("#doc-tobe-deleted").val(docref.text());
            var message = "Are you sure you want to delete the document <strong>";
            message = message.concat(docname,"</strong> ?");
            $("#alert-doc-delete").html(message);
            $("#modal-delete-doc").css('display', 'block');
            e.stopPropagation();
          });

        $("#cancel-delete-doc").click(function() {
            $("#modal-delete-doc").css('display', 'none');
        });

        $(".collapsable-table-row").click(function() {
            next = $(this).next();
            next.toggleClass('tr-uncollapsed');
            arrow = $(this).children().children().last();
            if ( arrow.hasClass('glyphicon-menu-up') )
            {
              arrow.addClass('glyphicon-menu-down');
              arrow.removeClass('glyphicon-menu-up');
            }
            else {
              arrow.removeClass('glyphicon-menu-down');
              arrow.addClass('glyphicon-menu-up');
            }
        });
});
