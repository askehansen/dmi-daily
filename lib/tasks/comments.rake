namespace :comments do
  desc "Fetches new comment and delivers to inbox"
  task fetch: :environment do
    comment = Comment.fetch
    
    unless comment.same_as?(Comment.latest)
      comment.save!
      CommentMailer.new_comment(comment).deliver
    end
  end

end
