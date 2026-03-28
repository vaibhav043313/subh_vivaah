class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_one :preference, dependent: :destroy

  has_many :matches, dependent: :destroy
  has_many :conversations_as_lower, class_name: "Conversation", foreign_key: :user_lower_id, dependent: :destroy
  has_many :conversations_as_higher, class_name: "Conversation", foreign_key: :user_higher_id, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy

  def conversations
    Conversation.for_user(self)
  end
end
