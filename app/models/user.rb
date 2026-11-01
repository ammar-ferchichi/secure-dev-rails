class User < ApplicationRecord
  ROLES = %w[ user admin ].freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :documents, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end
end
