require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
