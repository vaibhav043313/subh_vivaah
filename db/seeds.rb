# Sample data for development and demos (idempotent where possible).

demo = User.find_or_initialize_by(email: "priya@example.com")
if demo.new_record?
  demo.password = "password123"
  demo.password_confirmation = "password123"
  demo.premium = true
  demo.last_seen_at = Time.current
  demo.save!
  demo.create_profile!(
    first_name: "Priya",
    last_name: "Sharma",
    date_of_birth: 30.years.ago.to_date,
    gender: :female,
    city: "Delhi",
    state: "Delhi",
    country: "India",
    religion: "Hindu",
    caste: "Brahmin",
    profession: "Software Engineer",
    education: "B.Tech Computer Science",
    mother_tongue: "Hindi",
    height_cm: 163,
    income: 8,
    marital_status: "Never Married",
    verified: true,
    has_photo: true,
    completion_score: 95,
    bio: "Warm, family-oriented, and curious about the world. I enjoy weekend hikes, home cooking, and meaningful conversation. Looking for a partner who values honesty, growth, and shared traditions with a modern outlook."
  )
end

first_names = %w[Aarav Ananya Vikram Priya Rohan Meera Karan Aditi Neha Arjun]
city_state = [
  ["Bangalore", "Karnataka"],
  ["Mumbai", "Maharashtra"],
  ["Hyderabad", "Telangana"],
  ["Chennai", "Tamil Nadu"],
  ["Pune", "Maharashtra"]
]
castes = %w[Brahmin Kshatriya Vaishya]
educations = ["B.Tech / BE", "MBA / PGDM", "PhD / MPhil"]
professions = ["Software Engineer", "Doctor", "Business Owner"]
tongues = %w[Hindi Tamil Telugu]

48.times do |i|
  email = "member#{i + 1}@example.com"
  user = User.find_by(email: email)
  next if user

  u = User.new(
    email: email,
    password: "password123",
    password_confirmation: "password123",
    premium: (i % 5).zero?,
    last_seen_at: (i % 3).zero? ? Time.current : 2.hours.ago
  )
  u.save!
  city, state = city_state[i % city_state.length]
  Profile.create!(
    user: u,
    first_name: first_names[i % first_names.length],
    last_name: %w[Malhotra Iyer Kapoor Singh Reddy].sample,
    date_of_birth: ((25 + (i % 12)).years.ago).to_date,
    gender: i.even? ? :male : :female,
    city: city,
    state: state,
    country: "India",
    religion: "Hindu",
    caste: castes[i % castes.length],
    profession: professions[i % professions.length],
    education: educations[i % educations.length],
    mother_tongue: tongues[i % tongues.length],
    height_cm: 155 + (i % 35),
    verified: (i % 4) != 0,
    has_photo: true,
    marital_status: "Never Married",
    income: 6 + (i % 8),
    completion_score: 40 + (i % 55),
    bio: "Family-oriented, career-focused, looking for a respectful partnership."
  )
end

puts "Seeded demo user priya@example.com / password123 and sample profiles."
