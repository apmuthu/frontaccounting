$(function(){
	$('.dragbox')
	.each(function(){
		$(this).hover(function(){
			$(this).find('h2').addClass('collapse');
		}, function(){
		$(this).find('h2').removeClass('collapse');
		})
		.find('h2').hover(function(){
			$(this).find('.configure').css('visibility', 'visible');
		}, function(){
			$(this).find('.configure').css('visibility', 'hidden');
		})
		.click(function(){
			$(this).siblings('.dragbox-content').toggle();
			updateWidgetData();
		})
		.end()
		.find('.configure').css('visibility', 'hidden');
	});
    
	$('.column').sortable({
		connectWith: '.column',
		handle: 'h2',
		cursor: 'move',
		placeholder: 'placeholder',
		forcePlaceholderSize: true,
		opacity: 0.4,
		start: function(event, ui){
			//Firefox, Safari/Chrome fire click event after drag is complete, fix for that
			if($.browser.mozilla || $.browser.safari) 
				$(ui.item).find('.dragbox-content').toggle();
		},
		stop: function(event, ui){
			ui.item.css({'top':'0','left':'0'}); //Opera fix
			if(!$.browser.mozilla && !$.browser.safari)
				updateWidgetData();
		}
	})
	.disableSelection();
});

function updateWidgetData(){
	var items=[];
	$('.column').each(function(){
		var columnId=$(this).attr('id');
		$('.dragbox', this).each(function(i){
			var collapsed=0;
			if($(this).find('.dragbox-content').css('display')=="none")
				collapsed=1;
			var item={
				id: $(this).attr('id').substring(4),
				collapsed: collapsed,
				order : i,
				column: columnId.substring(6)
			};
			items.push(item);
		});
	});
	var sortorder={ items: items };
			
	//Pass sortorder variable to server using ajax to save state
	$.post('modules/dashboard/updatePanels.php', 'data='+$.toJSON(sortorder), function(response){
		if(response=="success")
			$("#console").html('<div class="success">Saved</div>').hide().fadeIn(1000);
		setTimeout(function(){
			$('#console').fadeOut(1000);
		}, 2000);
	});
}
function updateToDoData(id){
	$.post('modules/dashboard/completedreminder.php', 'data='+$.toJSON(id), function(response){
    if(response=="success") {
        $("#console").html('<div class="success">Saved</div>').hide().fadeIn(1000);
        var table = document.getElementById("reminder");
		var rowCount = table.rows.length;
		for(var i=0; i<rowCount; i++) {
			var row = table.rows[i];
			var chkbox = row.cells[0].childNodes[0];
			if(null != chkbox && true == chkbox.checked) {
				table.deleteRow(i);
				rowCount--;
				i--;
			}
		}
	}
    setTimeout(function(){
        $("#console").fadeOut(1000);
    }, 2000);
    });
}
