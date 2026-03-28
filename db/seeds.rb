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

# Blog articles (idempotent by slug)
[
  {
    title: "First meeting tips: respect, boundaries, and family",
    slug: "first-meeting-tips",
    excerpt: "How to plan a calm first meeting when both families are involved.",
    body: "Start in a neutral place if possible, keep the first meeting focused on getting to know values and expectations rather than rushing decisions.\n\nBe punctual, dress appropriately, and listen as much as you speak. If something feels off, it is fine to pause and continue the conversation later with people you trust.",
    published_at: 2.weeks.ago
  },
  {
    title: "Building an honest matrimony profile",
    slug: "honest-matrimony-profile",
    excerpt: "Why clarity beats exaggeration — and what to include in your bio.",
    body: "Write about your lifestyle, what you are looking for in a partner, and how you see family and career fitting together. Use recent photos and avoid hiding important facts; trust builds from the first conversation.\n\nUpdate your profile as life changes so matches see the real you.",
    published_at: 1.week.ago
  },
  {
    title: "Safety online: red flags and healthy pace",
    slug: "safety-online-matrimony",
    excerpt: "Protect your privacy until you are comfortable — and when to escalate concerns.",
    body: "Never share passwords, OTPs, or urgent money transfers with someone you only know from the platform. Keep early chats on the app, meet in public when you advance, and tell a friend or family member your plans.\n\nReport suspicious behaviour through our feedback form so we can review.",
    published_at: 3.days.ago
  }
].each do |attrs|
  BlogPost.find_or_initialize_by(slug: attrs[:slug]).tap do |post|
    post.assign_attributes(attrs)
    post.save!
  end
end

# Demo payments & subscription for Priya (optional display on account pages)
if demo.persisted?
  unless demo.payments.exists?(external_reference: "seed-demo-gold")
    demo.payments.create!(
      amount_cents: 149_900,
      currency: "INR",
      plan_name: "Gold — 6 months",
      status: "paid",
      description: "Demo seed payment",
      paid_at: 10.days.ago,
      external_reference: "seed-demo-gold"
    )
  end
  unless demo.subscriptions.exists?(plan_key: "gold_6m")
    demo.subscriptions.create!(
      plan_key: "gold_6m",
      status: "active",
      starts_on: 10.days.ago.to_date,
      ends_on: (10.days.ago + 6.months).to_date
    )
  end
end

puts "Seeded demo user priya@example.com / password123, sample profiles, blog posts, and demo billing for Priya."
