class UserPersonJoin < ActiveRecord::Base
  belong_to :user
  belong_to :person
end
