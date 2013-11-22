# coding: UTF-8
require 'will_paginate/array'
class ProductInfosController < ApplicationController
  before_filter :log_in, only: [:new, :create, :edit, :destroy]
  MILE_TO_M = 1609.344
  def index
    price_min = (params[:price_min].present? ? params[:price_min] : 0).to_f;
    price_max = (params[:price_max].present? ? params[:price_max] : 1000000000).to_f;
    if params[:sort] == 'price low to high'
      order = 'price ASC'
    elsif params[:sort] == 'price high to low'
      order = 'price DESC'
    else
      order = 'post_date DESC'
    end

    if params[:search].present? || params[:distance].present?
      if params[:distance].present?
        distance = params[:distance].to_f * MILE_TO_M
        @product_infos = ProductInfo.search params[:search], geo: [@lat, @lng], with: {geodist: 0.0..distance, price: price_min..price_max},
          order: order, page: params[:page], per_page: per_page
      else
        @product_infos = ProductInfo.search conditions: {title_body: params[:search]}, with: {price: price_min..price_max},
          order: order, page: params[:page], per_page: per_page
      end
    elsif params[:tag].present?
      @product_infos = ProductInfo.tagged_with(params[:tag]).where('price <= ? AND price >= ?', price_max, price_min).order(order).paginate(:page => params[:page], per_page: per_page)
    else
      @product_infos = ProductInfo.where('price <= ? AND price >= ?', price_max, price_min).order(order).paginate(:page => params[:page], per_page: per_page)
    end
  end

  def new
    @product_info = ProductInfo.new
    3.times{@product_info.assets.build}
  end

  def edit
    begin
      @product_info = ProductInfo.find(params[:id])
      if @product_info.user_id != @current_user.id
        flash[:error] = 'only author can edit a post'
        render :show
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Can not find this post'
      redirect_to product_infos_path
    end
  end

  def update
    @product_info = ProductInfo.find(params[:id])
    if @product_info.user_id == @current_user.id
      @product_info.assign_attributes(params[:product_info])
      if params[:address][:same_as_user]
        @product_info.address = @current_user.address
        @product_info.city = @current_user.city
        @product_info.state = @current_user.state
      else
        @product_info.address = "#{params[:address][:address1]} #{params[:address][:address2]}"
        @product_info.city = params[:address][:city]
        @product_info.state = params[:address][:state]
      end
      if @product_info.save
        flash[:notice] = 'Successfully updated your post.'
        render :show
      else
        render :edit
      end
    else
      flash[:error] = 'only author can edit a post'
      render :show
    end
  end

  def destroy
    begin
      @product_info = ProductInfo.find(params[:id])
      if @product_info.user_id == @current_user.id
        @product_info.destroy
        flash[:notice] = 'Your post has been closed'
        redirect_to product_infos_path
      else
       flash[:error] = 'only author can delete a post'
       render :show
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Can not find this post'
      redirect_to product_infos_path
    end
  end

  def create
    @product_info = ProductInfo.new(params[:product_info])
    @product_info.user = @current_user
    @product_info.source = ProductInfo::LOCAL
    if params[:address][:same_as_user]
      @product_info.address = @current_user.address
      @product_info.city = @current_user.city
      @product_info.state = @current_user.state
    else
      @product_info.address = "#{params[:address][:address1]} #{params[:address][:address2]}"
      @product_info.city = params[:address][:city]
      @product_info.state = params[:address][:state]
    end
    @product_info.post_date = DateTime.now
    if @product_info.save
      redirect_to product_infos_path 
    else
      flash[:error] ||= ''
      @product_info.errors.full_messages.each do |error|
        flash[:error] += "#{error}" 
      end
      render :new 
    end
  end

  def show
    begin
      @product_info = ProductInfo.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Can not find this post'
      redirect_to product_infos_path
    end
  end

  def tags_search
    @match_tags =  ActsAsTaggableOn::Tag.where('name like ?', "%#{params[:term]}%")
    respond_to do |format|
      format.json { render json: @match_tags }
    end
  end

  def more_tag
    @length = (params[:base]? params[:base] : 0).to_i + 10
    @tags = ProductInfo.tag_counts.order('tags_count DESC').limit(@length)
  end
end