$(function(){
    $('.calendar').fullCalendar({
        weekends: false,
        firstDay: 1,
        businessHours: {
            start: '08:00',
            end: '21:00',
            dow: [1,2,3,4,5]
        },
        events: {
            url: $('.calendar').data('source'),
            type: 'GET'
        },
        header:{
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        views: {
            basic: {
                // options apply to basicWeek and basicDay views
            },
            agenda: {
                // options apply to agendaWeek and agendaDay views
            },
            week: {
                // options apply to basicWeek and agendaWeek views
            },
            day: {
                // options apply to basicDay and agendaDay views
            }
        }
    });

    $('.calendar-week').fullCalendar({
        weekends: false,
        firstDay: 1,
        defaultView: 'week'
    });
});