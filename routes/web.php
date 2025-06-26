<?php

use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::name('users.')->group(function () {
    Route::get('/', [UserController::class, 'showForm'])->name('showForm');
    Route::post('/create', [UserController::class, 'store'])->name('store');
    Route::get('/list', [UserController::class, 'index'])->name('index');
});
