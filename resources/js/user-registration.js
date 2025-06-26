$(function() {
  const $form      = $('#registrationForm');
  const $submitBtn = $('#submitBtn');
  const $btnText   = $('#btnText');
  const $btnSpin   = $('#btnSpinner');
  const $tbody     = $('#usersTable tbody');

  // CSRF header
  $.ajaxSetup({
    headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') }
  });

  // Load and render all users
  function loadUsers() {
    $.getJSON('/list')
      .done(data => {
        $tbody.empty();
        data.data.forEach(u => {
          $tbody.append(`
            <tr>
              <td>${u.id}</td>
              <td>${u.name}</td>
              <td>${u.email}</td>
              <td>${new Date(u.created_at).toLocaleString()}</td>
            </tr>
          `);
        });
      })
      .fail(() => {
        console.error('Failed to load users.');
      });
  }

  // initial load
  loadUsers();

  // clear validation messages
  function clearErrors() {
    $form.find('.is-invalid').removeClass('is-invalid');
    $form.find('.invalid-feedback').text('');
  }

  // show returned validation errors
  function showErrors(errors) {
    for (let f in errors) {
      let msgs = errors[f].join(' ');
      let $inp = $form.find(`[name="${f}"]`);
      $inp.addClass('is-invalid')
          .siblings('.invalid-feedback')
          .text(msgs);
    }
  }

  // handle form submit
  $submitBtn.on('click', function() {
    clearErrors();
    $submitBtn.prop('disabled', true);
    $btnText.addClass('d-none');
    $btnSpin.removeClass('d-none');

    $.post({
      url: $form.attr('action'),
      data: $form.serialize(),
      dataType: 'json'
    })
    .done(res => {
      if (res.success) {
        $form[0].reset();
        loadUsers();
        $('<div class="alert alert-success">User registered!</div>')
          .prependTo($form)
          .delay(2000).fadeOut(400, function(){ $(this).remove(); });
      }
    })
    .fail(xhr => {
      if (xhr.status === 422 && xhr.responseJSON.errors) {
        showErrors(xhr.responseJSON.errors);
      } else {
        alert('An unexpected error occurred.');
      }
    })
    .always(() => {
      $submitBtn.prop('disabled', false);
      $btnSpin.addClass('d-none');
      $btnText.removeClass('d-none');
    });
  });
});
