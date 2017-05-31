# == Schema Information
#
# Table name: core_comments
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  role             :string(255)      default("comments")
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_core_comments_on_commentable_id    (commentable_id)
#  index_core_comments_on_commentable_type  (commentable_type)
#  index_core_comments_on_user_id           (user_id)
#

class Core::Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('updated_at DESC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user, class_name: 'Directory::User'


  def project
  	((commentable_type == "Pms::Task" and commentable.task_list and commentable.task_list.taskable_type == "Pms::Project") ? commentable.task_list.taskable : nil)
  end
  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
    	commentable_type: commentable_type,
        comment: comment,
        user: [user.first_name, user.last_name, user.username],
        project: (project ? project.title : nil),
        created_date: created_at.strftime("%Y-%m-%d")
    }
  end

  def self.filter_options
    {
        filter_box: [

        ],
        filter_aggregates: [

        ]
    }
  end
  #-----------------------------------------------------
end
