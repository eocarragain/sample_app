require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "should display count of micropsts" do
    before {visit root_path}
    it {should have_content('0 microposts')}

    describe "when there is one Post" do
      before do
        FactoryGirl.create(:micropost, user: user)
        visit root_path
      end
      it {should have_content('1 micropost')}
    end

    describe "when there are multiple posts" do
      before do
        5.times { FactoryGirl.create(:micropost, user: user)}
        visit root_path
      end
      it {should have_content( "#{ Micropost.count } microposts")}
    end
  end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as incorrect user" do
      let(:user2) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user2)
        visit user_path(user2)
      end

      it "should not have delete link" do
         expect(page).to_not have_selector("a", text: "delete")
      end
    end
  end
end
