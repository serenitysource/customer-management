<?php

# CategoryController

namespace App\Http\Controllers;

use App\Models\CustomerCategory;

class CategoryController extends Controller
{
    /**
     * Display a listing of all customer categories.
     */
    public function index()
    {
        $categories = CustomerCategory::all();

        return response()->json($categories);
    }
}
