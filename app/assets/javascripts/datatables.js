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

    $('table.simple-datatable').each(function(){
        $(this).DataTable({
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
});