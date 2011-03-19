# == Schema Information
# Schema version: 20110317153230
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,  :presence   => true,
										:length     => { :maximum => 50 }

	validates :email, :presence   => true,
										:format     => { :with => email_regex },
										:uniqueness => { :case_sensitive => false }

	# Automatically create the virtual attribute 'password confirmation'.
	validates :password, :presence     => true,
											 :confirmation => true,
											 :length       => { :within => 6..40 }

	# BUG: it seems as if by delaying the call to before_save that we have
	#			 introduced a bug because has_password? seems like it will fail
	#			 if it is called prior to calling save()
	#
	before_save :encrypt_password

	# Return true if user's password matches the submitted password
	def has_password?(submitted_password)
		self.encrypted_password == encrypt(submitted_password)
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil  if user.nil?
		return user if user.has_password?(submitted_password)
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end

	private
		
		# TODO:  why is this not @password instead?  I am really confused at this point
		# 			with this syntax and style
		#				I thought self.encrypted_password pointed to a class variable
		#				or soemthing along those lines.. since variables are like so:
		#
		# 			instance variable:
		#							@instance_variable
		#				class variable:
		#							@@class_variable
		#				accessor:
		#							self.password()
		#							password()
		#							password = "value"
		#							passwd = password()
		#
		#  def self.encrypted_password
		#			# defines a class method called encrypted_password
		#	 end
		#
		#	 def encrypted_password
		#			# defines an instance method
		#	 end
		#
		#	 I believe it is because we defined them as accessors
		#	 so we're referencing the accessor (attribute) password (or self.password)
		#	 rather than the instance variable used for them (but it's probably
		#  really just a hash used to store instance variables for the accessors)
		#

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
