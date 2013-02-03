require 'spec_helper'

describe HomeController do
  describe '#index' do
    it 'should render a page' do
      get :index
      response.status.should eql 200
    end
  end
end