function validateAlert(index, form, $event) {
    event.preventDefault();
    var objDelete = document.forms["objAlter-"+index]["delete"].value;
    if (objDelete != null) {
        Swal.fire({
            title: 'Você tem certeza?',
            text: "Você não será capaz de reverter isso!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sim, deletar!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
    }
}