# coding: UTF-8
require 'spec_helper'

describe ProductInfosController do
  describe 'new' do
    it 'initializes product_info and its assets' do
      ProductInfosController.any_instance.stub(:log_in).and_return(true)
      get 'new'
      expect(assigns(:product_info)).not_to eq nil
    end
  end

  describe 'show' do
    let!(:product_info) { ProductInfo.create!(post_date: DateTime.now, title: 'title1', body: 'body1', source: ProductInfo::LOCAL, price: 50, tag_list: 'a tag') }

    it 'initializes product_info and its assets' do
      ProductInfo.stub(:find).and_return product_info
      get 'show', id: 0
      expect(assigns(:product_info)).not_to eq nil
    end
  end

  describe 'index' do
    let!(:product_info1) { ProductInfo.create!(post_date: DateTime.now, title: 'title1', body: 'body1', source: ProductInfo::LOCAL, price: 50, tag_list: 'a tag') }
    let!(:product_info2) { ProductInfo.create!(post_date: DateTime.now, title: 'title2', body: 'body2', source: ProductInfo::LOCAL, price: 150, tag_list: 'another tag') }

    it 'only displays products within the range of price_min and price_max' do
      get 'index', price_min:0, price_max: 100
      expect(assigns(:product_infos)).to include product_info1
      expect(assigns(:product_infos)).not_to include product_info2
    end

    it 'only displays products with the tag user wants to search' do
      product_info1.tag_list = 'a tag'
      product_info2.tag_list = 'another tag'
      get 'index', tag: 'a tag'
      expect(assigns(:product_infos)).to include product_info1
      expect(assigns(:product_infos)).not_to include product_info2
    end

    it 'displays products base on the order user selected' do
      get 'index', sort: 'price low to high'
      expect(assigns(:product_infos).index(product_info1)).to be < assigns(:product_infos).index(product_info2)
    end
  end

  describe 'edit' do
    before(:each) do
      ProductInfosController.any_instance.stub(:log_in).and_return(true)
    end

    let!(:product_info) { ProductInfo.create!(post_date: DateTime.now, title: 'title1', body: 'body1', source: ProductInfo::LOCAL, price: 50, tag_list: 'a tag') }
    it 'initializes product_info and its assets' do
      #Fixnum.any_instance.stub(:==).and_return true
      ProductInfo.stub(:find).and_return product_info
      get 'edit', id: 0
      expect(assigns(:product_info)).not_to eq nil
    end
  end
end