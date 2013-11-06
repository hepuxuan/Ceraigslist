# coding: UTF-8
class UsersController < ApplicationController
  before_filter :log_in, only: [:edit, :destroy]
  def new
  	@user = User.new
  end

  def edit
  	@user = @current_user
  end

  def update
    @user = User.find params[:id]
    @user.address = "#{params[:address][:address1]} #{params[:address][:address2]}"
    if @user.update_attributes params[:user]
      flash[:notice] = 'you have successfully update user information'
      redirect_to product_infos_path
    else
      flash[:error] = ''
      @user.errors.full_messages.each do |error|
        flash[:error] += "#{error}" 
      end
      render :edit
    end
  end

  def create
  	@user = User.new params[:user]
  	if @user.save
  		session[:email] = @user.email
      session[:timestamp] = DateTime.now()
  		flash[:notice] = 'you have successfully signed up'
  		redirect_to product_infos_path
  	else
  	  flash[:error] = ''
      @user.errors.full_messages.each do |error|
        flash[:error] += "#{error}" 
      end
      @user = User.new
      render :new 
  	end
  end

  def forgot_password
  end

  def email_password
    @user = User.where(email: params[:user][:email]).first
    if @user
      new_password = (0...8).map { (65 + rand(26)).chr }.join
      @user.password = new_password
      if @user.save
        UserMailer.password_email(@user, new_password).deliver
        flash[:notice] = 'check your email, new password has been created for you'
      else
        flash[:error] = 'can not generate new password'
      end
      redirect_to new_session_path
    else
      flash[:error] = 'invalid email address'
      render :forgot_password
    end
  end
end