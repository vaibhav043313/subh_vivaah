# 💍 SubhVivaah – Scalable Matrimonial Platform

SubhVivaah is a high-performance matrimonial web application built using Ruby on Rails, designed to scale to **1M+ active users**.
The system follows a **modular monolith architecture** with an API-first approach, enabling seamless transition to microservices and mobile platforms in the future.

---

## 🚀 Tech Stack

* **Backend:** Ruby on Rails (latest stable)
* **Database:** PostgreSQL
* **Frontend:** Rails (Hotwire – Turbo + Stimulus)
* **Caching:** Redis
* **Background Jobs:** Sidekiq
* **Search Engine:** Elasticsearch (planned)
* **Authentication:** Devise

---

## 🧠 System Architecture

* Modular Monolith (domain-based structure)
* API-first design for future mobile apps
* Scalable database design with indexing
* Background processing for heavy tasks

---

## 📦 Core Features

### 👤 User Authentication

* Secure authentication using Devise
* Email-based login (extendable to phone/OTP)

### 🧾 Profile Management

* Detailed user profiles
* Gender, religion, location, profession, bio
* Profile visibility controls (planned)

### 🎯 Matching Engine (V1)

* Matches based on:

  * Gender
  * Religion
  * Location
* Precomputed matches stored in DB
* Scalable service-based architecture

### ❤️ Match Feed

* Displays potential matches
* Optimized queries using indexing
* Ready for pagination & infinite scroll

---

## 🗂️ Project Structure

```
app/
├── models/
│   ├── user.rb
│   ├── profile.rb
│   ├── preference.rb
│   └── match.rb
│
├── controllers/
│   ├── profiles_controller.rb
│   └── matches_controller.rb
│
├── services/
│   ├── profiles/
│   │   └── create_profile.rb
│   └── matching/
│       └── generate_matches.rb
│
├── views/
│   ├── profiles/
│   └── matches/
```

---

## ⚙️ Setup Instructions

### 1. Clone Repository

```bash
git clone <your-repo-url>
cd subh-vivaah
```

---

### 2. Install Dependencies

```bash
bundle install
```

---

### 3. Setup Database

```bash
rails db:create
rails db:migrate
```

---

### 4. Start Server

```bash
rails server
```

Visit: http://localhost:3000

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

* Avoid heavy queries on every request
* Enables fast match feed loading

### ✅ Service Layer

* Keeps business logic out of controllers/models
* Easy to scale into microservices later

### ✅ Indexed Queries

* Improves performance for large datasets
* Optimized for filtering use cases

---

## 📈 Scalability Strategy (1M+ Users)

### Database

* Indexed columns (gender, religion, city)
* Partitioning (planned)
* Read replicas (future)

### Caching

* Redis for:

  * Profile caching
  * Match feed caching
  * Sessions

### Background Jobs

* Sidekiq for:

  * Match generation
  * Notifications
  * Image processing

### Search

* Elasticsearch for advanced matchmaking (planned)

---

## 🔐 Security & Privacy

* Strong parameter filtering
* Authentication via Devise
* Profile visibility controls (planned)
* GDPR-ready architecture (future)

---

## 🚧 Upcoming Features

* Advanced matching algorithm (score-based)
* Age filtering (DOB-based)
* Like / Reject system
* Real-time updates (Turbo Streams)
* Messaging system
* Mobile app (React Native)

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request

---

## 📌 Author

**Vaibhav Kushwaha**
Senior Ruby on Rails Developer

---

## ⭐ Vision

To build a **highly scalable, intelligent matrimonial platform** that delivers meaningful matches with speed, reliability, and privacy.
