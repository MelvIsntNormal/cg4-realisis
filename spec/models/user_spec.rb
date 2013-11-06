require 'spec_helper'

describe User do
  before { @user = User.new(
    name: "Test",
    email: "test@test.org",
    password: "foobarss",
    password_confirmation: "foobarss",
  ) }
  
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  
  it { should be_valid }
  
  describe "provides a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end

  
  describe "returns value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "fails to provide any password" do
    before { @user = User.new(
      name: "Test",
      email: "test@test.org",
      password: " ",
      password_confirmation: " ",
    ) }
    
    it { should_not be_valid }
  end
  
  describe "fails password verification" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "does not provide infromation" do
    before { @user.name = nil }
    it { should_not be_valid }
    
    before do
      @user.email = nil
      @user.name = "Test"
    end
    it { should_not be_valid }
  end
  
  describe "provides name that is too large" do
    before { @user.name = "a" * 65}
    it {should_not be_valid}
  end
  
  describe "provides invalid email" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "provides valid email" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "provides used email" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
end
