require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { Category.create( { name: "I am a category" } ) }
  let(:create_11_categories) {
    Category.create( { name: "Grocery" } )
    Category.create( { name: "Animals" } )
    Category.create( { name: "Home and Garden" } )
    Category.create( { name: "Toys" } )
    Category.create( { name: "Clothing" } )
    Category.create( { name: "Health and Beauty" } )
    Category.create( { name: "Sports and Outdoors" } )
    Category.create( { name: "Automotive" } )
    Category.create( { name: "Books" } )
    Category.create( { name: "Movies" } )
    Category.create( { name: "Electronic" } )
  }

  describe "Actions" do
    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end

      it "assigns @categories" do
        create_11_categories

        get :index
        expect(assigns(:categories)).to eq(Category.all)
        expect(assigns(:categories).count).to eq(11)
      end
    end
  end
end
