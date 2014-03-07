class Device < ActiveRecord::Base
	has_many :messages
	has_one :location
end
