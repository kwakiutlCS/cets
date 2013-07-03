class CommentsController < ApplicationController
  before_filter :authenticate_user! 

  
  def create
    comment=Comment.new(params[:comment])
    comment.save
    
    render json: {text: comment.text, name: current_user.username}
  end


  

end
