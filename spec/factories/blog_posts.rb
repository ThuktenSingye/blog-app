FactoryBot.define do
  factory :blog_post do
    title { "Default Title" }
    body { "Default Body" }
    association :user # Automatically associates a user for the blog post
  end
end
