class Friendship < ActiveRecord::Base
  track_actions :new_friendship, :after_create, :keep_params => ["friend.name", "friend.url", "friend.profile_custom_icon"], :custom_user => :person
  
  belongs_to :person, :foreign_key => :person_id
  belongs_to :friend, :class_name => 'Person', :foreign_key => 'friend_id'
end
