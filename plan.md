# Photo

- Show the photo mainly
- On the right
  - Who posted it, their profile picture
  - Details about it that have been filled in
    - Bus Type
    - Livery
    - Fleet Number
    - Reg Code
    - (this can be filled in by searching for a bus and selecting it, or manually)
  - Buttons to view where this button was taken, button to show where the bus is now, live
- On the bottom
  - A 5 star rating buttons
  - Favourite button
  - Comment secion below everthing, be able to comment to other comments

# Home page

- Either show recently uploaded photos, or photos similar to ones you have favourited

# Search page

- Be able to search by the many things, bus type / livery / fleet number / reg code

# Franchises page

- Show bee network / tfl etc
- Show details about specific ones
- Show photos from all the operators
- Or, click on an operator to see their photos

# Pages for certain things

- Be able to favourite, rate, comment on resources
  - Services
  - Operators
  - Buses
  - Vehicle Type
  - Livery

# Track which lines you've been on

- Create lists, add franchises or operator's lines to it

# SQL

- User

```sql
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  username TEXT NOT NULL,
  display_name TEXT,
  password TEXT NOT NULL
);
```

- Vechile

```
Copy from the bustimes server's table
```

- Bus Photo Details

```sql
CREATE TABLE IF NOT EXISTS bus_photo_details (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  linked_vehicle INTEGER REFERENCES vehicles(id),
  overwrite_linked_vehicle INTEGER DEFAULT 0,
  fleet_number TEXT,
  reg TEXT,
  livery_name TEXT,
  special_name TEXT,
  operator TEXT,
  bus_tye TEXT
);
```

- Bus Photo

```sql
CREATE TABLE IF NOT EXISTS bus_photos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uploaded_by INTEGER REFERENCES users(id) NOT NULL,
  details INTEGER REFERENCES bus_photo_details(id) NOT NULL,
  created_at TEXT NOT NULL
);
```

- Bus Photo Edited

```sql
CREATE TABLE IF NOT EXISTS bus_photo_edit_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  details_key TEXT NOT NULL,
  details_value TEXT NOT NULL,
  details_old_value TEXT NOT NULL,
  edited_at TEXT NOT NULL,
  edited_by INTEGER REFERENCES users(id) NOT NULL
);
```

- Bus Photo Rating

```sql
CREATE TABLE IF NOT EXISTS bus_photo_rating (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  rating INTEGER NOT NULL,
  rating_by INTEGER REFERENCES users(id) NOT NULL,
  photo_id INTEGER REFERENCES bus_photos(id) NOT NULL,
  created_at TEXT NOT NULL
);
```

- Bus Photo Favourite

```sql
CREATE TABLE IF NOT EXISTS bus_photo_favourite (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  photo_id INTEGER REFERENCES bus_photos(id) NOT NULL,
  favourited_by INTEGER REFERENCES users(id) NOT NULL,
  created_at TEXT NOT NULL
);
```

- Bus Photo View

```sql
CREATE TABLE IF NOT EXISTS bus_photo_view (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  photo_id INTEGER REFERENCES bus_photos(id) NOT NULL,
  user_id INTEGER REFERENCES users(id),
  ip_hash TEXT
);
```

# HTTP

`/api/bus-photos/search`

- `?reg=`
- `?livery=`
- `?fleet=`
- `?vehicle_type=`
- `?author=`
- `?before=`
- `?after=`
