class Core::CommentsController < ApplicationController

  def create
    @object = params[:core_comment][:commentable_type].constantize.find(params[:core_comment][:commentable_id])
    @comment = Core::Comment.new(comments_params)
    @comment.user = current_user
    @comment.save

  end

  def destroy
    @comment = Core::Comment.find(params[:id])
    @id = @comment.id
    @comment.destroy
  end

  def edit
    @comment = Core::Comment.find(params[:id])
  end

  def update
    @comment = Core::Comment.find(params[:id])
    @comment.update_attributes(comments_params)
  end

  def cancel
    @comment = Core::Comment.find(params[:id])
  end

  private
  def comments_params
    params.require(:core_comment)
        .permit(
            :commentable_id, :commentable_type, :comment
        )
  end
end