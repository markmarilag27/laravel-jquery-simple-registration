@extends('layouts.app')

@section('title','Register & Users')

@section('content')
<div class="row">
  <div class="col-md-4">
    <h4>Register</h4>
    <form id="registrationForm" action="{{ route('users.store') }}" method="POST" novalidate>
      @csrf
      @foreach (['name','email','password','password_confirmation'] as $field)
        <div class="mb-3">
          <label class="form-label text-capitalize">{{ str_replace('_',' ',$field) }}</label>
          <input
            type="{{ $field==='email'?'email':(Str::contains($field,'password')?'password':'text') }}"
            name="{{ $field }}"
            class="form-control"
            required
          >
          <div class="invalid-feedback"></div>
        </div>
      @endforeach

      <button id="submitBtn" type="button" class="btn btn-primary">
        <span id="btnText">Submit</span>
        <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status"></span>
      </button>
    </form>
  </div>

  <div class="col-md-8">
    <h4>Users List</h4>
    <table class="table table-striped" id="usersTable">
      <thead>
        <tr>
          <th>ID</th><th>Name</th><th>Email</th><th>Registered At</th>
        </tr>
      </thead>
      <tbody>
      </tbody>
    </table>
  </div>
</div>
@endsection
