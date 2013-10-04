# coding: UTF-8
require 'spec_helper'

describe SessionsController do
  describe 'create' do
    let(:user) {[User.new(name: 'puxuan he', email: 'invalid', password: 'valid', 
      password_confirmation: 'valid', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')]}

    before(:each) do
      User.stub(:where).and_return user
    end

    it 'redirects to index page with valid email and password' do
      post :create, email: 'puxuan.he@cerner.com', password: 'valid'
      expect(response).to redirect_to product_infos_path
    end

    it 'displays an error message with incorrect email and password' do
      post :create, email: 'puxuan.he@cerner.com', password: 'invalid'
      expect(flash[:error]).to include 'The email address or password you entered isn\'t correct.'
    end
  end

  describe 'destroy' do
    it 'sets email to nil' do
      delete :destroy, id: 0
      expect(session[:email]).to eq nil
    end
  end
end