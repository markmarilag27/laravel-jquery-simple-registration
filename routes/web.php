<?php

use App\Http\Controllers\FileController;
use Illuminate\Support\Facades\Route;

Route::name('files.')->group(function () {
    Route::get('/',      [FileController::class, 'showForm'])->name('form');
    Route::post('/upload', [FileController::class, 'upload'])->name('upload');
});
