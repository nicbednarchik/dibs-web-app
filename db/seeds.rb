# db/seeds.rb

puts "Seeding database…"

# Wipe old records (optional — only in dev!)
User.destroy_all
Clothe.destroy_all

# Create some users
u1 = User.create!(
  email: "alice@example.com",
  password: "password",
  username: "alice"
)

u2 = User.create!(
  email: "bob@example.com",
  password: "password",
  username: "bob"
)

u3 = User.create!(
  email: "carol@example.com",
  password: "password",
  username: "carol"
)

# Create clothes for Alice
c1 = u1.clothes.create!(
  title: "GATR Band Shirt",
  item_type: "Shirt",
  description: "Limited edition band tee.",
  size: "M",
  condition: "Good",
  brand: "GATR"
)

c2 = u1.clothes.create!(
  title: "Vintage Denim Jacket",
  item_type: "Jacket",
  description: "Classic Levi’s style denim.",
  size: "L",
  condition: "Excellent",
  brand: "Levi’s"
)

# Create clothes for Bob
c3 = u2.clothes.create!(
  title: "Running Shoes",
  item_type: "Shoes",
  description: "Comfy Nike running shoes.",
  size: "9",
  condition: "Fair",
  brand: "Nike"
)

# Example: Bob calls dibs on Alice’s band shirt
c1.update!(dibbed_by: u2, dibbed_at: Time.current)

puts "Seed complete! Users: #{User.count}, Clothes: #{Clothe.count}"
