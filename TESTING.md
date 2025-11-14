# Testing Checklist

## Prerequisites
✅ Docker Desktop is installed and running on Windows

## Setup Test

```powershell
# Navigate to project directory
cd d:\Development\developer_task

# Run setup (this will take 3-5 minutes first time)
.\setup.ps1
```

Expected output:
- ✅ Laravel 11 installed
- ✅ Docker containers started (app, db, node)
- ✅ Composer dependencies installed
- ✅ NPM dependencies installed
- ✅ Database migrated
- ✅ Categories seeded (Gold, Silver, Bronze)
- ✅ Frontend assets built

## Application Test

### 1. Open Application
- Open browser: http://localhost:8000
- ✅ Page loads without errors
- ✅ Header shows "Customer Management"
- ✅ Search box visible
- ✅ "Create Customer" button visible
- ✅ Table headers: Name, Reference, Category, Contacts, Actions

### 2. Test Create Customer

Click "Create Customer" button:
- ✅ Modal opens with title "Create Customer"
- ✅ Fields visible:
  - Name (text input)
  - Reference (text input)
  - Category (dropdown with Gold, Silver, Bronze)
  - Start Date (date picker)
  - Description (text area)
- ✅ Save and Back buttons visible

Fill in customer:
```
Name: Test Company Ltd
Reference: CUST001
Category: Gold
Start Date: 2024-01-15
Description: Test customer for demonstration
```

Click "Save":
- ✅ Modal closes
- ✅ Customer appears in table
- ✅ Gold badge visible
- ✅ 0 contacts shown
- ✅ Edit and Delete links visible

### 3. Test Edit Customer

Click "Edit" on the customer:
- ✅ Modal opens with title "Edit Customer"
- ✅ All fields populated with existing data
- ✅ "Contacts" section visible (not in Create mode)
- ✅ "Add Contact" button visible

Change name to: "Test Company Limited"
Click "Save":
- ✅ Modal closes
- ✅ Name updated in table

### 4. Test Create Contact

Click "Edit" on customer again:
Click "Add Contact" button:
- ✅ Contact modal opens
- ✅ Title: "Add Contact"
- ✅ Fields: First Name, Last Name
- ✅ Save and Cancel buttons

Fill in contact:
```
First Name: John
Last Name: Doe
```

Click "Save":
- ✅ Contact modal closes
- ✅ Contact appears in contacts table
- ✅ Edit and Delete links visible
- ✅ Contacts count shows "1" in main table

Add another contact:
```
First Name: Jane
Last Name: Smith
```
- ✅ Two contacts now visible

### 5. Test Edit Contact

In customer modal, click "Edit" on a contact:
- ✅ Contact modal opens with "Edit Contact" title
- ✅ Fields populated
Change last name to "Johnson"
- ✅ Updates successfully

### 6. Test Delete Contact

Click "Delete" on a contact:
- ✅ Confirmation modal appears
- ✅ Shows contact name in message
- ✅ Cancel and Delete buttons visible

Click "Delete":
- ✅ Modal closes
- ✅ Contact removed from list
- ✅ Contact count decrements

Click "Cancel" on delete:
- ✅ Modal closes without deleting

### 7. Test Search

Close customer modal.

In search box, type "Test":
- ✅ Customer appears in results

Type "CUST001":
- ✅ Customer appears in results

Type "xyz":
- ✅ No results shown
- ✅ "No customers found" message

Clear search:
- ✅ All customers visible

### 8. Test Multiple Customers

Create more customers:

Customer 2:
```
Name: Silver Corp
Reference: CUST002
Category: Silver
```

Customer 3:
```
Name: Bronze Industries
Reference: CUST003
Category: Bronze
```

- ✅ All three customers visible
- ✅ Different colored badges (Gold=yellow, Silver=gray, Bronze=orange)

### 9. Test Delete Customer

Click "Delete" on a customer:
- ✅ Confirmation modal appears
- ✅ Message warns about deleting contacts too

Click "Delete":
- ✅ Modal closes
- ✅ Customer removed from table
- ✅ Contacts also deleted (verify with database if needed)

### 10. Test Validation

Click "Create Customer", leave fields empty, click "Save":
- ✅ HTML5 validation triggers (required fields)

Fill only name and reference, click "Save":
- ✅ Category required validation

Try duplicate reference:
- ✅ Backend validation error shown

### 11. Test Category Badges

Verify badge colors:
- ✅ Gold: Yellow background
- ✅ Silver: Gray background
- ✅ Bronze: Orange background

### 12. Test Responsive Design

Resize browser window:
- ✅ Table remains usable
- ✅ Modals centered
- ✅ Mobile-friendly layout

## Docker Tests

### Check Containers Running

```powershell
docker-compose ps
```

Expected:
- ✅ slipstream_app: Up (port 8000)
- ✅ slipstream_db: Up (port 3306)
- ✅ slipstream_node: Exited (normal after build)

### Check Logs

```powershell
docker-compose logs app
```
- ✅ No errors
- ✅ Laravel boot messages

### Access Database

```powershell
docker-compose exec db mysql -u slipstream_user -pslipstream_password slipstream
```

Run queries:
```sql
SELECT * FROM customer_categories;
-- ✅ Returns Gold, Silver, Bronze

SELECT * FROM customers;
-- ✅ Returns created customers

SELECT * FROM contacts;
-- ✅ Returns created contacts

exit;
```

### Test Hot Reload (Development Mode)

Stop current containers:
```powershell
docker-compose down
```

Start dev mode:
```powershell
.\dev.ps1
```

- ✅ Vite dev server starts
- ✅ App accessible at http://localhost:8000

Make a change in CustomerList.vue (change header text):
- ✅ Browser auto-refreshes
- ✅ Change visible immediately

## Performance Tests

### Database Performance
Create 10+ customers:
- ✅ Search still fast
- ✅ Table loads quickly

### API Response
Open browser DevTools → Network tab:
- ✅ API calls return in < 500ms
- ✅ Proper HTTP status codes (200, 201, 204)

## Error Handling Tests

### Network Error Simulation
Stop database:
```powershell
docker-compose stop db
```

Try to create customer:
- ✅ Error handled gracefully
- ✅ User gets feedback

Restart:
```powershell
docker-compose start db
```

## Clean Up Test

```powershell
# Stop everything
docker-compose down

# Remove volumes (deletes database)
docker-compose down -v

# Re-setup
.\setup.ps1
```

- ✅ Everything works fresh
- ✅ Categories re-seeded
- ✅ No leftover data

## Final Verification

✅ All CRUD operations work
✅ Search works
✅ Modals work
✅ Validation works
✅ Relationships work (contacts deleted with customer)
✅ Categories seeded correctly
✅ Docker setup works
✅ Documentation is clear
✅ No console errors
✅ No PHP errors
✅ Professional UI

## Ready for Submission!

If all tests pass ✅, you're ready to:
1. Create Git repository
2. Push commits
3. Submit to Slipstream

See GIT_GUIDE.md for detailed instructions.
