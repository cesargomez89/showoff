require "securerandom"

class Seeder
  def self.run
    create_users
  end

  def self.create_users
    puts "Creating users..."

    emails = [
      "admin@example.com",
      "user@example.com"
    ]

    emails.each do |email|
      user = User.find_by(email: email)
      next if user

      User.create!(
        email: email,
        password: "password",
        password_confirmation: "password",
        uid: SecureRandom.uuid
      )
    end
  end
end

puts "Seeding..."
Seeder.run
puts "Seeding complete!"
