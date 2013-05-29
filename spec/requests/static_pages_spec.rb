require 'spec_helper'

describe "StaticPages" do

  describe "home page" do
    it "should have content" do
      visit root
      page.should have_selector("h1", text:"Chess Endgame Practise")
    end
  end

end
