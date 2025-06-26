<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class FileController extends Controller
{
    public function showForm()
    {
        return view('files.index');
    }

    public function upload(Request $request): JsonResponse
    {
        $request->validate([
            'image' => 'required|image|max:2048',
        ]);

        $path = $request->file('image')->store('uploads', 'public');

        $url = asset("storage/{$path}");

        return response()->json([
            'success' => true,
            'url'     => $url,
        ]);
    }
}
