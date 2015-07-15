require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "POST #create" do
    it "creates a session tied to user_id" do
    end
  end

  describe "private methods" do
    context "#find_user" do
      it "returns a user instance" do

      end

    end

    context "#session_params" do
      params = [:email, :password, :user_id]

      params.each do |param|
        it "can access the #{param}" do

        end
      end
    end

  end

end
