require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    before { visit root_path }
    subject { page }
    it { should have_content("Under Construction") }
  end
end
