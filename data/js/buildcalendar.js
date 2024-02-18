/* vim: set noexpandtab t s=4 sw=4: */
function buildCalendar(dlpath) {
	document.addEventListener('DOMContentLoaded', function() {
		const cal = new FullCalendar.Calendar(document.getElementById('calendar'), {
			headerToolbar: {
				start: 'prev,next today',
				center: 'title',
				end: 'dayGridMonth,dayGridWeek,listWeek'
			},
			customButtons: {
				download: {
					text: 'Ladda ner kalender',
					click: function () {window.location = dlpath}
				}
			},
			initialView: 'dayGridMonth',
			weekNumbers: true,
			locale: 'sv',
			eventClick: function (info) {alert('Event: ' + info.event.title)},
			eventMouseEnter: function (mouseEnterInfo) { },
			eventMouseLeave: function (mouseLeaveInfo) { },
		})
		cal.render()
		$.get(dlpath).then(function (data) {
			var c = new ICAL.Component(ICAL.parse(data.trim()))
			var events = $.map(c.getAllSubcomponents("vevent"), function(item){
				if(item.getFirstPropertyValue("class") == "PRIVATE"){
					return null
				} else {
					var res = {
						"title": item.getFirstPropertyValue("summary"),
						"location": item.getFirstPropertyValue("location"),
					};
					var rrule = item.getFirstPropertyValue("rrule")
					if (rrule != null) {
						//event recurs
						res.rrule = {}
						if (rrule.freq) res.rrule.freq = rrule.freq
						if (rrule.parts.BYDAY) res.rrule.byweekday = rrule.parts.BYDAY
						if (rrule.until) res.rrule.until = rrule.until.toString()
						if (rrule.until) res.rrule.until = rrule.until.toString()
						if (rrule.interval) res.rrule.interval = rrule.interval
						var dtstart = item.getFirstPropertyValue("dtstart").toString()
						var dtend = item.getFirstPropertyValue("dtend").toString()
						res.rrule.dtstart = dtstart
						//count duration ms
						var startdate = new Date(dtstart)
						var enddate = new Date(dtend)
						res.duration = enddate - startdate
					} else {
						if (item.hasProperty("dtstart") && item.hasProperty("dtend")) {
							res.start = item.getFirstPropertyValue("dtstart").toString()
							res.end = item.getFirstPropertyValue("dtend").toString()
						} else {
							return null
						}
					}
					return res
				}
			})
			cal.setOption('events', events)
			if (events.length > 0) cal.setOption('footerToolbar', {end:'download'})
		})
	})
}
