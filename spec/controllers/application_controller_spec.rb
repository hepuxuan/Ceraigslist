# coding: UTF-8
require 'spec_helper'

describe ApplicationController do
  let(:user) {[User.new(name: 'puxuan he', email: 'invalid', password: 'valid', password_confirmation: 'valid', 
    address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')]}
  let(:application_controller) {ApplicationController.new}
  before(:each) do
    User.stub(:where).and_return user
  end

  describe 'set_user_and_tags' do

  end

  describe 'get_user' do
    it 'returns instance of user when session is valid' do
      session = {email: 'puxuan.he@cerner.com', timestamp: DateTime.now}
      expect(application_controller.get_user session).to eq user.first
    end

    it 'returns nil when timestamp expire' do
      session = {email: 'puxuan.he@cerner.com', timestamp: 2.hours.ago}
      expect(application_controller.get_user session).to eq nil
    end
  end

  describe 'set_user_and_tags' do
    it 'calls get_user and tag_counts' do
      
    end
  end
end