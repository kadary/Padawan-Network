class User < ActiveRecord::Base
	has_many 	:received_messages,
				:class_name => 'Message',
				:primary_key=>'padawan_id',
				:foreign_key => 'recepient_id'
				#:order => "messages.created_at DESC",
				#:conditions => ["messages.recepient_deleted = ?", false]
	include BCrypt
	attr_accessor :password
	before_save :encrypt_password, :create_unique_profile_id
	
	validates_confirmation_of :password , :message => "Le mot de passe n'est pas correct."
    validates_presence_of :password, :message => "Saisis ton mot de passe STP"
    validates_presence_of :email,:message=>"Tu dois saisir une adresse email"
    validates_uniqueness_of :email,:message => "Cet email est utilise par un autre padawan."
    validates_presence_of :first_name , :message => "C'est quoi ton prenom padawan"
    validates_presence_of :last_name, :message => "J'ai besoin de connaitre ton nom padawan"


	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def create_unique_profile_id
		begin
			self.profile_id=SecureRandom.base64(8)
		end while self.class.exists?(:profile_id =>profile_id)
	end
	
	def unread_messages?
		unread_message_count > 0 ? true : false
	end
	
	# Returns the number of unread messages for this user
	def unread_message_count
		eval 'messages.count(:conditions => ["recepient_id = ? AND read_at IS NULL", self.padawan_id])'
	end
end
