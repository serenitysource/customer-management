<?php

# ContactController
namespace App\Http\Controllers;

use App\Models\Contact;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ContactController extends Controller
{
    /**
     * Display a listing of contacts for a customer.
     */
    public function index($customerId)
    {
        $customer = Customer::findOrFail($customerId);
        $contacts = $customer->contacts;

        return response()->json($contacts);
    }

    /**
     * Store a newly created contact.
     */
    public function store(Request $request, $customerId)
    {
        $customer = Customer::findOrFail($customerId);

        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $contact = $customer->contacts()->create($request->all());

        return response()->json([
            'message' => 'Contact created successfully',
            'contact' => $contact
        ], 201);
    }

    /**
     * Update the specified contact.
     */
    public function update(Request $request, $id)
    {
        $contact = Contact::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $contact->update($request->all());

        return response()->json([
            'message' => 'Contact updated successfully',
            'contact' => $contact
        ]);
    }

    /**
     * Remove the specified contact.
     */
    public function destroy($id)
    {
        $contact = Contact::findOrFail($id);
        $contact->delete();

        return response()->json([
            'message' => 'Contact deleted successfully'
        ]);
    }
}
