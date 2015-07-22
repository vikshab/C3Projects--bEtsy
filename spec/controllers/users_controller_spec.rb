require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "a user can see their user page" do
    before :each do
      @user = User.create(name: "Name1", email: "name@email.com", password: "foobar", password_confirmation: "foobar")
    end

    it "renders the #show view" do
      @user.session.create
      get :show, id: @user
      expect(response).to render_template("show")
    end

    it "renders the #new view" do
      get :new, id: @user
      expect(response).to render_template("new")
    end
  end
  #
  #   it "increases the rank when you upvote" do
  #     patch :upvote, id: @album
  #     @album.reload
  #     expect(@album.rank).to eq(1)
  #   end
  #
  #   it "deletes a given album" do
  #     delete :destroy, id: @album
  #     expect(Album.count).to eq(0)
  #   end
  #
  # end
  #
  # describe "makes new albums" do
  #   let(:valid_album) do {
  #     album: { name: "name1"}
  #   }
  #   end
  #
  #   it "creates a new Album" do
  #     post :create, valid_album
  #     expect(Album.count).to eq(1)
  #   end
  #
  #   it "redirects to the album show page" do
  #     post :create, valid_album
  #     expect(response).to redirect_to(album_path(assigns(:media)))
  #   end
  # end
  #
  # describe "albums can be edited" do
  #   let(:album) {Album.create(name: "name1", rank: 20)}
  #
  #   it "updates an album with valid params" do
  #     post :update, id: album, album: {name: "Edited name", rank: 20}
  #     album.reload
  #     expect(album.name).to eq("Edited name")
  #   end
  #
  #   it "redirects to the album show page" do
  #     post :update, id: album, album: {name: "Edited name", rank: 20}
  #     expect(response).to redirect_to(album_path(assigns(:media)))
  #   end


end
