require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should have_many :blog_posts}
  end
end
