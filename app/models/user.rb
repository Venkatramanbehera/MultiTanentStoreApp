class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Update roles:
  # customer: 0 (Buys things)
  # store_admin: 1 (Manages a specific shop)
  # platform_admin: 9 (You - Manages the SaaS)
  enum :role, { customer: 0, store_admin: 1, platform_admin: 9 }
end
