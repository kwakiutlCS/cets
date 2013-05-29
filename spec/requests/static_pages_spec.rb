require 'spec_helper'

describe "StaticPages" do

  describe "home page" do
    it "should have content" do
      visit "/static_pages/home"
      page.should have_selector("h1", text:"Chess Endgame Practise")
    end
  end

end
