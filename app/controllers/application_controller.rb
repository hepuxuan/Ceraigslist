# coding: UTF-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_user_and_tags

  def per_page
    50
  end

  def log_in
    if @current_user.nil?
      flash[:error] = 'Please log in first'
      redirect_to new_session_path
    end
  end

  def set_user_and_tags
    @current_user ||= get_user(session)  
    @tags ||=  ProductInfo.tag_counts.order('tags_count DESC').limit(10)
  end
  
  def get_user (session)
    if(session[:email])
      user=User.where(email: session[:email]).first
      if(!user||(DateTime.now().to_i()-session[:timestamp].to_i)>(60*60))
        nil
      else 
        user
      end
    end
  end
end
