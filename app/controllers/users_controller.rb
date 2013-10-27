# coding: UTF-8
class UsersController < ApplicationController
  before_filter :log_in, only: [:create, :edit, :destroy]
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
      flash[:notice] = "you have successfully update user information"
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
  		flash[:notice] = "you have successfully signed up"
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
end