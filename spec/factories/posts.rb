FactoryGirl.define do
  factory :post do

      title "new post title"
      body "new post body"
      topic_id { create(:topic).id }
      user_id {create(:user, :sequenced_username, :sequenced_email).id }

      trait :with_image do
        image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
      end

      trait :sequenced_title do
        title
      end

      trait :sequenced_body do
        body
      end

  end
end
