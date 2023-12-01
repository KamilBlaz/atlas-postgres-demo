table "bookings" {
  schema = schema.cd
  column "bookid" {
    null = false
    type = integer
  }
  column "facid" {
    null = false
    type = integer
  }
  column "memid" {
    null = false
    type = integer
  }
  column "starttime" {
    null = false
    type = timestamp
  }
  column "slots" {
    null = false
    type = integer
  }
  primary_key {
    columns = [column.bookid]
  }
  foreign_key "bookings_facid_fkey" {
    columns     = [column.facid]
    ref_columns = [table.facilities.column.facid]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  foreign_key "bookings_memid_fkey" {
    columns     = [column.memid]
    ref_columns = [table.members.column.memid]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
}
table "facilities" {
  schema = schema.cd
  column "facid" {
    null = false
    type = integer
  }
  column "name" {
    null = false
    type = character_varying(100)
  }
  column "membercost" {
    null = false
    type = numeric
  }
  column "guestcost" {
    null = false
    type = numeric
  }
  column "initialoutlay" {
    null = false
    type = numeric
  }
  column "monthlymaintenance" {
    null = false
    type = numeric
  }
  primary_key {
    columns = [column.facid]
  }
}
table "members" {
  schema = schema.cd
  column "memid" {
    null = false
    type = integer
  }
  column "surname" {
    null = false
    type = character_varying(200)
  }
  column "firstname" {
    null = false
    type = character_varying(200)
  }
  column "address" {
    null = false
    type = character_varying(300)
  }
  column "zipcode" {
    null = false
    type = integer
  }
  column "telephone" {
    null = false
    type = character_varying(20)
  }
  column "recommendedby" {
    null = true
    type = integer
  }
  column "joindate" {
    null = false
    type = timestamp
  }
  primary_key {
    columns = [column.memid]
  }
  foreign_key "members_recommendedby_fkey" {
    columns     = [column.recommendedby]
    ref_columns = [table.members.column.memid]
    on_update   = NO_ACTION
    on_delete   = SET_NULL
  }
}
table "employees" {
  schema = schema.public
  column "id" {
    null = false
    type = serial
  }
  column "name" {
    null = true
    type = character_varying(100)
  }
  column "email" {
    null = true
    type = character_varying(100)
  }
  primary_key {
    columns = [column.id]
  }
}
schema "cd" {
}
schema "public" {
  comment = "standard public schema"
}
