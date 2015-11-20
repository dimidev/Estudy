$(function(){
    $('table.datatable').each(function(){
        $(this).DataTable({
            processing: true,
            serverSide: true,
            ajax: $(this).data('source'),
            pagingType: "full_numbers",
            responsive: true,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            order: [],
            columnDefs: [
                {targets: 'no-sort', orderable: false},
                {targets: 'text-center', class: 'text-center'}
            ]
        });
    });

    $('table.full-length-datatable').each(function(){
        $(this).DataTable({
            dom: "<'pull-left'i><'pull-right'f>st",
            processing: true,
            serverSide: true,
            ajax: $(this).data('source'),
            responsive: true,
            order: [],
            columnDefs: [
                {targets: 'no-sort', orderable: false},
                {targets: 'text-center', class: 'text-center'}
            ]
        });
    });
});