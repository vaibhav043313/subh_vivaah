# 💍 SubhVivaah – Scalable Matrimonial Platform

Subh Vivaah is a matrimonial web application built with **Ruby on Rails 8**, designed to scale to **1M+ active users**.
The system follows a **modular monolith architecture** with room for an API-first approach later, so you can grow toward microservices and mobile clients without a ground-up rewrite.

---

## 🚀 Tech Stack

* **Backend:** Ruby on Rails **8.1** (Solid Cache, Solid Queue, Solid Cable)
* **Database:** PostgreSQL
* **Frontend:** Rails (**Hotwire** – Turbo + Stimulus), ERB, **importmap** (no Node bundler for app JS)
* **Assets:** **Propshaft**; global styles in `application.css` plus scoped sheets (`browse.css`, `messaging.css`, `auth.css`, etc.). **Tailwind** via the [Play CDN](https://tailwindcss.com/docs/installation/play-cdn) (preflight off so existing CSS stays intact)
* **Caching / jobs (in Gemfile):** Solid Cache & Solid Queue (not Redis + Sidekiq today)
* **Search engine:** Elasticsearch (planned; not in Gemfile yet)
* **Authentication:** Devise
* **Tests & quality:** RSpec, **RuboCop** (Rails Omakase + RSpec), Brakeman, `bundler-audit`, `importmap audit` (`bin/ci` runs the full pipeline)

*Optional / future stack pieces (commented or not wired):* Redis, Sidekiq, Kaminari, Elasticsearch gems.

---

## 🧠 System Architecture

* Modular monolith (profiles, matching, messaging, membership, content)
* Service objects for heavier flows (`Profiles::CreateProfile`, `Matching::GenerateMatches`)
* Scalable database design with indexing for browse and filters
* Background-friendly design (Solid Queue for future/heavy tasks)

---

## 📦 Core Features

### 👤 User Authentication

* Secure authentication using **Devise**
* Email-based login (extendable to phone/OTP)
* Header and redirects tuned for **Turbo** where it matters

### 🧾 Profile Management

* Detailed user profiles and preferences
* Gender, religion, location, profession, bio
* **Browse** with filters and lazy-loaded listing; **profile show** with similar profiles

### 🎯 Matching Engine (V1)

* Matches based on:

  * Gender
  * Religion
  * Location
* Precomputed matches stored in the DB
* Service-based generation (`Matching::GenerateMatches`)

### ❤️ Match Feed

* Surfaces potential matches from stored `Match` rows
* Indexed queries for filtering
* Ready for pagination and richer UX

### 💬 Messaging & alerts

* **Conversations** and **messages** between members
* **Notifications** (list, mark read, header badge); app time zone **Asia/Kolkata** for messaging labels

### 💳 Membership & content

* **Pricing**, **subscription**, and **payment history** views (checkout can be wired when you go live)
* **Blog** and static pages: about, FAQ, contact, feedback, terms, privacy

---

## 🗂️ Project Structure

```
app/
├── models/
│   ├── user.rb
│   ├── profile.rb
│   ├── preference.rb
│   ├── match.rb
│   ├── conversation.rb
│   ├── message.rb
│   ├── notification.rb
│   └── …
│
├── controllers/
│   ├── profiles_controller.rb
│   ├── conversations_controller.rb
│   ├── messages_controller.rb
│   ├── notifications_controller.rb
│   ├── blog_posts_controller.rb
│   ├── pages_controller.rb
│   ├── pricing_controller.rb
│   └── …
│
├── services/
│   ├── profiles/
│   │   └── create_profile.rb
│   └── matching/
│       └── generate_matches.rb
│
├── views/
│   ├── profiles/
│   ├── conversations/
│   ├── shared/
│   └── …
```

---

## ⚙️ Setup Instructions

### 1. Clone Repository

```bash
git clone <your-repo-url>
cd subh_vivaah
```

---

### 2. Install Dependencies

```bash
bundle install
```

---

### 3. Setup Database

```bash
bin/rails db:prepare
```

Or use the full setup script (also clears logs/tmp):

```bash
bin/setup --skip-server
```

---

### 4. Start Server

```bash
bin/dev
```

Visit: http://localhost:3000

---

### Style, security, and tests (optional but recommended)

```bash
bin/rubocop              # Ruby style
bin/ci                   # setup + RuboCop + audits + RSpec + test seeds
bundle exec rspec        # tests only
```

---

## 🧪 Basic Flow (Test in Rails Console)

```ruby
user = User.first

# Create Profile
Profiles::CreateProfile.call(user, {
  first_name: "Vaibhav",
  date_of_birth: "1995-01-01",
  gender: "male",
  religion: "Hindu",
  city: "Delhi"
})

# Create Preference
Preference.find_or_create_by!(user: user).update!(
  gender: "female",
  religion: "Hindu",
  city: "Delhi"
)

# Generate Matches
Matching::GenerateMatches.call(user)
```

---

## 🧠 Key Design Decisions

### ✅ Precomputed Matches

* Avoid heavy matching queries on every request
* Enables fast match feed loading as data grows

### ✅ Service Layer

* Keeps orchestration out of bloated controllers/models
* Easier to move work to jobs or APIs later

### ✅ Indexed Queries

* Improves performance for browse and filter use cases
* Room to add search (e.g. Elasticsearch) when needed

---

## 📈 Scalability Strategy (1M+ Users)

### Database

* Indexed columns for common filters (gender, religion, city, etc.)
* Partitioning (planned)
* Read replicas (future)

### Caching

* **Solid Cache** today for Rails-friendly caching
* Redis-style caching (optional future) for hot keys, sessions, or feed caches if you add Redis

### Background Jobs

* **Solid Queue** for async work (match regeneration, notifications, heavy IO)
* Sidekiq remains a common choice if you standardise on Redis later

### Search

* Elasticsearch for advanced matchmaking (planned)

---

## 🔐 Security & Privacy

* Strong parameter filtering in controllers
* Authentication via Devise
* Run **Brakeman** and **bundler-audit** (`bin/ci` includes them)
* Terms/privacy copy in the app is **placeholder** until counsel-approved legal text ships

---

## 🚧 Upcoming Features

* Advanced matching (score-based, age rules)
* Like / reject (or similar) flows
* More **Turbo Streams** where real-time UX helps
* Payment provider integration for production checkout
* Mobile app or dedicated API clients (domain layer stays in Rails)

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch
3. Run `bin/ci` or at least `bin/rubocop` and `bundle exec rspec`
4. Commit changes
5. Open a Pull Request

---

## 📌 Author

**Vaibhav Kushwaha**
Senior Ruby on Rails Developer

---

## ⭐ Vision

To build a **highly scalable, intelligent matrimonial platform** that delivers meaningful matches with speed, reliability, and privacy.
