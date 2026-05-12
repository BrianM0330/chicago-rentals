require "json"

puts "Seeding started"

file_path = Rails.root.join("db", "data", "loc_and_buildings.json")
data = JSON.parse(File.read(file_path))

puts "Seeding #{data["localities"].size} localities"

data["localities"].each do |loc_data|
  locality = Locality.find_or_initialize_by(
    name: loc_data["name"],
    city: loc_data["city"]
  )

  locality.state = loc_data["state"]
  locality.save!
end

puts "Seeding #{data["buildings"].size} buildings"

data["buildings"].each do |b_data|
  locality = Locality.find_by!(
    name: b_data["locality_name"],
    city: b_data["city"]
  )

  building = Building.find_or_initialize_by(
    street: b_data["street"],
    street_number: b_data["street_number"],
    city: b_data["city"]
  )

  building.display_name = b_data["display_name"]
  building.state = b_data["state"]
  building.postal_code = b_data["postal_code"]
  building.latitude = b_data["latitude"]
  building.longitude = b_data["longitude"]
  building.locality = locality
  building.save!
end

users = [
  { email_address: "maya@example.com", password: "password123" },
  { email_address: "jordan@example.com", password: "password123" },
  { email_address: "sam@example.com", password: "password123" }
]

puts "Seeding #{users.size} users"

users.each do |user_data|
  user = User.find_or_initialize_by(email_address: user_data[:email_address])
  user.password = user_data[:password]
  user.save!
end

pin_data = [
  {
    slug: "logan-square-2522-1br-2025",
    user_email: "maya@example.com",
    locality_name: "Logan Square",
    building_name: "The Logan",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 205000,
    listed_rent_cents: 215000,
    square_feet: 690,
    move_in_year: 2025,
    reported_on: Date.new(2026, 1, 15),
    note: "Renewal offer was lower after asking about comparable units nearby.",
    source: "tenant_report",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "renewal,one-bedroom"
  },
  {
    slug: "wicker-park-1278-2br-2025",
    user_email: "jordan@example.com",
    locality_name: "Wicker Park",
    building_name: "Wicker Park Commons",
    kind: "rent",
    bedrooms: 2,
    rent_cents: 310000,
    listed_rent_cents: 325000,
    square_feet: 940,
    move_in_year: 2025,
    reported_on: Date.new(2026, 2, 3),
    note: "Second-floor unit facing Milwaukee. Street noise is noticeable on weekends.",
    source: "tenant_report",
    parking_included: false,
    utilities_included: true,
    broker_fee_cents: 50000,
    tags: "two-bedroom,utilities"
  },
  {
    slug: "south-loop-1210-studio-2026",
    user_email: "sam@example.com",
    locality_name: "South Loop",
    building_name: "NEMA Chicago",
    kind: "rent",
    bedrooms: 0,
    rent_cents: 240000,
    listed_rent_cents: 248500,
    square_feet: 510,
    move_in_year: 2026,
    reported_on: Date.new(2026, 3, 20),
    note: "Amenities are strong, but mandatory monthly fees add up quickly.",
    source: "listing_followup",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "studio,fees"
  },
  {
    slug: "loop-sears-tower-1br-2026",
    user_email: "jordan@example.com",
    locality_name: "Loop",
    building_name: "Sears Tower",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 295000,
    listed_rent_cents: 305000,
    square_feet: 720,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 12),
    note: "Seed pin for testing map placement around the Sears Tower / Willis Tower area.",
    source: "seed_data",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "loop,map-test"
  },
  {
    slug: "uptown-5050-discussion",
    user_email: "maya@example.com",
    locality_name: "Uptown",
    building_name: "The Draper",
    kind: "discussion",
    bedrooms: nil,
    rent_cents: nil,
    listed_rent_cents: nil,
    square_feet: nil,
    move_in_year: nil,
    reported_on: Date.new(2026, 4, 5),
    note: "Has anyone renewed here recently? Curious how flexible management has been.",
    source: "discussion",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: nil,
    tags: "discussion,renewal"
  },
  {
    slug: "irl-lakeshore-east-tides-studio-2026",
    user_email: "maya@example.com",
    locality_name: "Lakeshore East",
    building_name: "The Tides",
    kind: "rent",
    bedrooms: 0,
    rent_cents: 290000,
    listed_rent_cents: nil,
    square_feet: 625,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 12),
    note: "IRL Rent API: Self found listing, secured over winter.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "irl-rent,studio,lakeshore-east"
  },
  {
    slug: "irl-wabash-burnham-1br-2026",
    user_email: "jordan@example.com",
    locality_name: "Wabash Corridor",
    building_name: "Burnham Park Plaza",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 210000,
    listed_rent_cents: 190000,
    square_feet: 900,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 8),
    note: "IRL Rent API: First year in 2022 rent was $1,900, increased to $2,100 by 2026. Landlord attempts to raise rent every year but does the request too late. $400 lease fee each time the lease is signed.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 40000,
    tags: "irl-rent,one-bedroom,wabash-corridor,fees"
  },
  {
    slug: "irl-wabash-1400-1br-2026",
    user_email: "sam@example.com",
    locality_name: "Wabash Corridor",
    building_name: "1400 S Wabash",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 200000,
    listed_rent_cents: nil,
    square_feet: 750,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 8),
    note: "IRL Rent API: Zillow, private landlord.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "irl-rent,one-bedroom,wabash-corridor"
  },
  {
    slug: "irl-lincoln-park-2424-clark-2br-2026",
    user_email: "maya@example.com",
    locality_name: "Lincoln Park",
    building_name: "2424 N Clark",
    kind: "rent",
    bedrooms: 2,
    rent_cents: 320000,
    listed_rent_cents: nil,
    square_feet: nil,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 6),
    note: "IRL Rent API: In-unit laundry, all utilities included except electric/internet.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: true,
    broker_fee_cents: 0,
    tags: "irl-rent,two-bedroom,lincoln-park,utilities"
  },
  {
    slug: "irl-lake-view-east-505-belmont-1br-2026",
    user_email: "jordan@example.com",
    locality_name: "Lake View East",
    building_name: "505 W Belmont",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 198000,
    listed_rent_cents: 198000,
    square_feet: nil,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 5),
    note: "IRL Rent API: $1,980 without utility bundle. Utility bundle adds $80 for water, sewer, gas, and internet. Package theft issue noted.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "irl-rent,one-bedroom,lake-view-east,fees"
  },
  {
    slug: "irl-rush-division-14-elm-studio-2026",
    user_email: "sam@example.com",
    locality_name: "Rush & Division",
    building_name: "14 W Elm",
    kind: "rent",
    bedrooms: 0,
    rent_cents: 165000,
    listed_rent_cents: 155000,
    square_feet: nil,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 5),
    note: "IRL Rent API: Rent was $1,550 when they moved in, raised by $100 every renewal.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: false,
    broker_fee_cents: 0,
    tags: "irl-rent,studio,rush-division,renewal"
  },
  {
    slug: "irl-gold-coast-1220-state-studio-2026",
    user_email: "maya@example.com",
    locality_name: "Gold Coast",
    building_name: "1220 North State Parkway",
    kind: "rent",
    bedrooms: 0,
    rent_cents: 182500,
    listed_rent_cents: nil,
    square_feet: nil,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 5),
    note: "IRL Rent API: All utilities included when they moved out, but reported horrible management and a bad cockroach issue.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: true,
    broker_fee_cents: 0,
    tags: "irl-rent,studio,gold-coast,management"
  },
  {
    slug: "irl-lincoln-park-443-wrightwood-1br-2026",
    user_email: "jordan@example.com",
    locality_name: "Lincoln Park",
    building_name: "443 West Wrightwood",
    kind: "rent",
    bedrooms: 1,
    rent_cents: 299900,
    listed_rent_cents: nil,
    square_feet: nil,
    move_in_year: 2026,
    reported_on: Date.new(2026, 5, 5),
    note: "IRL Rent API: Pay only electric.",
    source: "irl_rent_api",
    parking_included: false,
    utilities_included: true,
    broker_fee_cents: 0,
    tags: "irl-rent,one-bedroom,lincoln-park,utilities"
  }
]

puts "Seeding #{pin_data.size} pins"

pin_data.each do |pin_attrs|
  user = User.find_by!(email_address: pin_attrs[:user_email])
  locality = Locality.find_by!(name: pin_attrs[:locality_name], city: "Chicago")
  building = Building.find_by!(display_name: pin_attrs[:building_name])
  pin = Pin.find_or_initialize_by(slug: pin_attrs[:slug])

  pin.user = user
  pin.locality = locality
  pin.building = building
  pin.kind = pin_attrs[:kind]
  pin.latitude = building.latitude
  pin.longitude = building.longitude
  pin.hood = locality.name
  pin.bedrooms = pin_attrs[:bedrooms]
  pin.rent_cents = pin_attrs[:rent_cents]
  pin.listed_rent_cents = pin_attrs[:listed_rent_cents]
  pin.square_feet = pin_attrs[:square_feet]
  pin.move_in_year = pin_attrs[:move_in_year]
  pin.reported_on = pin_attrs[:reported_on]
  pin.note = pin_attrs[:source] == "irl_rent_api" ? nil : pin_attrs[:note]
  pin.source = pin_attrs[:source]
  pin.parking_included = pin_attrs[:parking_included]
  pin.utilities_included = pin_attrs[:utilities_included]
  pin.broker_fee_cents = pin_attrs[:broker_fee_cents]
  pin.tags = pin_attrs[:tags]
  pin.save!

  if pin_attrs[:source] == "irl_rent_api" && pin_attrs[:note].present?
    comment = Comment.find_or_initialize_by(
      user: user,
      pin: pin,
      body: pin_attrs[:note].delete_prefix("IRL Rent API: ")
    )
    comment.relationship = "renter"
    comment.save!
  end
end

irl_pin_path = Rails.root.join("db", "data", "irl_rent_pins.json")
irl_pin_data = JSON.parse(File.read(irl_pin_path))
irl_users = User.order(:email_address).to_a

puts "Seeding #{irl_pin_data.size} IRL Rent API pins"

irl_pin_data.each_with_index do |row, index|
  hood, latitude, longitude, rent, bedrooms, reported_on, building_name, note, parking_included, utilities_included = row
  locality = Locality.find_or_initialize_by(name: hood, city: "Chicago")
  locality.state = "IL"
  locality.save!

  display_name = building_name.presence || "IRL #{hood} Pin #{index + 1}"
  building = Building.find_by(display_name: display_name) || Building.find_or_initialize_by(
    street: "Seed Pin Ave",
    street_number: (10_000 + index).to_s,
    city: "Chicago"
  )

  building.display_name = display_name
  building.street = "Seed Pin Ave" if building.street.blank?
  building.street_number = (10_000 + index).to_s if building.street_number.blank?
  building.city = "Chicago"
  building.state = "IL"
  building.postal_code = "60600" if building.postal_code.blank?
  building.latitude = latitude
  building.longitude = longitude
  building.locality = locality
  building.save!

  pin = Pin.find_or_initialize_by(slug: "irl-rent-api-#{index + 1}")
  pin.user = irl_users[index % irl_users.size]
  pin.locality = locality
  pin.building = building
  pin.kind = "rent"
  pin.latitude = latitude
  pin.longitude = longitude
  pin.hood = hood
  pin.bedrooms = bedrooms
  pin.rent_cents = rent * 100
  pin.listed_rent_cents = nil
  pin.square_feet = nil
  pin.move_in_year = Date.parse(reported_on).year
  pin.reported_on = Date.parse(reported_on)
  pin.note = nil
  pin.source = "irl_rent_api"
  pin.parking_included = parking_included
  pin.utilities_included = utilities_included
  pin.broker_fee_cents = 0
  pin.tags = "irl-rent,#{hood.parameterize}"
  pin.save!

  if note.present?
    comment = Comment.find_or_initialize_by(
      user: pin.user,
      pin: pin,
      body: note
    )
    comment.relationship = "renter"
    comment.save!
  end
end

Pin.where(source: "irl_rent_api").where.not(note: nil).update_all(note: nil)

comments = [
  {
    user_email: "jordan@example.com",
    pin_slug: "logan-square-2522-1br-2025",
    body: "This matches what I saw for similar one-bedrooms nearby.",
    relationship: "neighbor"
  },
  {
    user_email: "sam@example.com",
    pin_slug: "wicker-park-1278-2br-2025",
    body: "The included utilities make this easier to compare against newer buildings.",
    relationship: "renter"
  },
  {
    user_email: "jordan@example.com",
    pin_slug: "uptown-5050-discussion",
    body: "A friend renewed there and only got a small increase after negotiating.",
    relationship: "former_resident"
  }
]

puts "Seeding #{comments.size} comments"

comments.each do |comment_data|
  user = User.find_by!(email_address: comment_data[:user_email])
  pin = Pin.find_by!(slug: comment_data[:pin_slug])
  comment = Comment.find_or_initialize_by(
    user: user,
    pin: pin,
    body: comment_data[:body]
  )

  comment.relationship = comment_data[:relationship]
  comment.save!
end

bookmarks = [
  { user_email: "maya@example.com", pin_slug: "wicker-park-1278-2br-2025" },
  { user_email: "jordan@example.com", pin_slug: "south-loop-1210-studio-2026" },
  { user_email: "sam@example.com", pin_slug: "logan-square-2522-1br-2025" }
]

puts "Seeding #{bookmarks.size} bookmarks"

bookmarks.each do |bookmark_data|
  user = User.find_by!(email_address: bookmark_data[:user_email])
  pin = Pin.find_by!(slug: bookmark_data[:pin_slug])

  Bookmark.find_or_create_by!(user: user, pin: pin)
end

pin_flags = [
  {
    user_email: "sam@example.com",
    pin_slug: "wicker-park-1278-2br-2025",
    reason: "needs_verification"
  }
]

puts "Seeding #{pin_flags.size} pin flags"

pin_flags.each do |flag_data|
  user = User.find_by!(email_address: flag_data[:user_email])
  pin = Pin.find_by!(slug: flag_data[:pin_slug])

  PinFlag.find_or_create_by!(
    user: user,
    pin: pin,
    reason: flag_data[:reason]
  )
end

puts "Seeding complete"
