module UsersHelper
	# Returns the Gravatar for the given user.
	def gravatar_for(status)
		@user = User.find(status.posted_by_uid)
		gravatar_id = Digest::MD5::hexdigest(@user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: @user.first_name, class: "statusimg")
  end
end
