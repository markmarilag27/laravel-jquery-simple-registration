@extends('layouts.app')

@section('title','AJAX File Upload')

@section('content')
<div class="row">
  <div class="col-md-6">
    <h4>Upload an Image</h4>
    <form id="uploadForm" enctype="multipart/form-data" novalidate>
      @csrf
      <div class="mb-3">
        <label class="form-label">Select Image</label>
        <input type="file" name="image" class="form-control" accept="image/*" required>
        <div class="invalid-feedback"></div>
      </div>
      <button id="uploadBtn" type="button" class="btn btn-primary">
        <span id="btnText">Upload</span>
        <span id="btnSpinner" class="spinner-border spinner-border-sm d-none"></span>
      </button>
    </form>
  </div>

  <div class="col-md-6">
    <h4>Preview</h4>
    <div id="preview" class="d-flex flex-wrap gap-2">
      {{-- Thumbnails will go here --}}
    </div>
  </div>
</div>
@endsection
