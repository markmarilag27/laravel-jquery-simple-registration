$(function() {
  const $form      = $('#uploadForm');
  const $btn       = $('#uploadBtn');
  const $btnText   = $('#btnText');
  const $btnSpin   = $('#btnSpinner');
  const $preview   = $('#preview');

  // set CSRF header for AJAX
  $.ajaxSetup({
    headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') }
  });

  // clear previous errors
  function clearErrors() {
    $form.find('.is-invalid').removeClass('is-invalid');
    $form.find('.invalid-feedback').text('');
  }

  // show validation errors
  function showErrors(errors) {
    for (let field in errors) {
      const msgs = errors[field].join(' ');
      const $input = $form.find(`[name="${field}"]`);
      $input.addClass('is-invalid');
      $input.siblings('.invalid-feedback').text(msgs);
    }
  }

  $btn.on('click', function() {
    clearErrors();

    // prepare UI
    $btn.prop('disabled', true);
    $btnText.addClass('d-none');
    $btnSpin.removeClass('d-none');

    const data = new FormData($form[0]);

    $.ajax({
      url: '/upload',
      method: 'POST',
      data: data,
      processData: false,
      contentType: false,
      dataType: 'json'
    })
    .done(res => {
      if (res.success) {
        // append thumbnail
        const img = $('<img>')
          .attr('src', res.url)
          .addClass('img-thumbnail')
          .css({ width: '120px', height: 'auto' });
        $preview.prepend(img);
      }
    })
    .fail(xhr => {
      if (xhr.status === 422 && xhr.responseJSON.errors) {
        showErrors(xhr.responseJSON.errors);
      } else {
        alert('Upload failed. Try again.');
      }
    })
    .always(() => {
      // reset button
      $btn.prop('disabled', false);
      $btnSpin.addClass('d-none');
      $btnText.removeClass('d-none');
      // clear file input
      $form[0].reset();
    });
  });
});
