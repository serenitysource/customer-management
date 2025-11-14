<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
# CustomerCategory

class CustomerCategory extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
    ];

    /**
     * Get the customers for this category.
     */
    public function customers()
    {
        return $this->hasMany(Customer::class, 'category_id');
    }
}
