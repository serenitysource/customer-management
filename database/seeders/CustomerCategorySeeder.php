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
        $categories = [
            [
                'name' => 'Gold',
                'description' => 'Premium tier customers with highest priority service and exclusive benefits'
            ],
            [
                'name' => 'Silver',
                'description' => 'Standard tier customers with regular service and standard benefits'
            ],
            [
                'name' => 'Bronze',
                'description' => 'Basic tier customers with essential service and basic benefits'
            ],
        ];

        foreach ($categories as $category) {
            CustomerCategory::updateOrCreate(
                ['name' => $category['name']],
                ['description' => $category['description']]
            );
        }
    }
}
