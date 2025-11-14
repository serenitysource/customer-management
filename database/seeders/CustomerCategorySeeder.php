<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\CustomerCategory;

class CustomerCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = ['Gold', 'Silver', 'Bronze'];

        foreach ($categories as $category) {
            CustomerCategory::firstOrCreate(['name' => $category]);
        }
    }
}
