json.array!(@messages) do |message|
  json.extract! message, :id, :sender_id, :recepient_id, :sender_deleted, :subject, :body, :read_at, :container
  json.url message_url(message, format: :json)
end
