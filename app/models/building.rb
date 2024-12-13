class Building < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values, dependent: :destroy
  has_many :custom_fields, through: :client

  validates :address, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :client, presence: true
end
