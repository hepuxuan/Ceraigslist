class EmailAlertsController < ApplicationController
  def index
    @email_alerts = @current_user.email_alerts
  end

  def new
    @email_alert = EmailAlert.new
  end

  def edit
    @email_alert = EmailAlert.find params[:id]
    if @email_alert.user_id != @current_user.id
      flash[:error] ||= 'permission denied'
      redirect_to email_alerts_path
    end
  end

  def destroy
    begin
      @email_alert = EmailAlert.find(params[:id])
      if @email_alert.user_id == @current_user.id
        @email_alert.destroy
        flash[:notice] = 'Your email alert have been removed'
        redirect_to email_alerts_path
      else
       flash[:error] = 'permission denied'
       render :show
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Can not find this email alert'
      redirect_to email_alerts_path
    end
  end

  def update
    @email_alert = EmailAlert.find params[:id]
    if @email_alert.user_id != @current_user.id
      flash[:error] ||= 'permission denied'
      redirect_to email_alerts_path
    end
    @email_alert.assign_attributes params[:email_alert]
    if @email_alert.save
      flash[:notice] = 'Successfully updated your post.'
      redirect_to email_alerts_path
    else
      render :edit
    end
  end

  def create
    @email_alert = EmailAlert.new params[:email_alert]
    @email_alert.user = @current_user
    if @email_alert.save
      redirect_to email_alerts_path
    else
      flash[:error] ||= ''
      @email_alert.errors.full_messages.each do |error|
        flash[:error] += "#{error}" 
      end
      render :new 
    end
  end
end
