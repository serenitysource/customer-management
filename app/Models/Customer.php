<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
# Customer
class Customer extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'reference',
        'category_id',
        'start_date',
        'description',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'start_date' => 'date:Y-m-d',
    ];

    /**
     * Get the category that owns the customer.
     */
    public function category()
    {
        return $this->belongsTo(CustomerCategory::class, 'category_id');
    }

    /**
     * Get the contacts for the customer.
     */
    public function contacts()
    {
        return $this->hasMany(Contact::class);
    }
}
