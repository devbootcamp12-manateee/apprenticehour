/* prepend new meeting into meetings index page */
var first_meeting = $('.row.meeting.form').next()

$('<%= escape_javascript(render(@meeting)) %>').insertBefore(first_meeting);
$('.row.meeting.form #new_meeting')[0].reset()