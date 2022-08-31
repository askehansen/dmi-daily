require './config/boot'
require './config/environment'

module Clockwork

  every 1.hour, "Fetch new comment and delivers to inbox" do
    comment = Comment.fetch
    
    unless comment.same_as?(Comment.latest)
      comment.save!
      CommentMailer.new_comment(comment).deliver
    end
  end

end