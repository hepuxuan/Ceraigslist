# coding: UTF-8
class SessionsController < ApplicationController
  def create
    email = params[:email].to_s
    password = params[:password].to_s
    user = User.where(email: email).first
    if user && user.authenticate(password)
      session[:email] = user.email
      session[:timestamp] = DateTime.now()
      redirect_to product_infos_path
    else 
      flash[:error] = "The email address or password you entered isn't correct."
      render 'new'
    end
  end

  def new
  end
  
  def destroy 
    session[:email] = nil
    flash[:notice] = "you have successfully logged out!"
    redirect_to product_infos_path
  end
end