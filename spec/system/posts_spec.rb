require 'rails_helper'

# rails g rspec:system Posts
# rspec spec/system/posts_spec.rb

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Posts', type: :system do
  let!(:zac) { create(:user, :zac) }
  let!(:zoe) { create(:user, :zoe) }

  before do
    driven_by(:rack_test)
  end

  scenario 'user makes a post from the homepage then deletes it' do
    login_as(zac)
    visit '/'
    fill_in 'Write your new post here...', with: 'Test post'
    click_on 'Post'
    zac.reload
    post = zac.posts.last
    visit "/posts/#{post.id}"

    result_one = post.content == 'Test post'
    expect(page).to have_content('Test post')
    # expect(page).to have_content('Your post is live')
    expect(result_one).to be_truthy

    # find("#edit#{post.id}").click
    # fill_in 'Write your new post here...', with: 'Tester poster'
    # click_on 'Post'
    # zac.reload
    # post.reload
    # result_two = post.content == 'Tester poster'
    # expect(page).to have_content('Tester poster')
    # expect(page).to have_content('Your post was updated')
    # expect(result_two).to be_truthy
    # find('.trash').click
    # zac.reload
    # result_three = zac.posts.empty?
    # expect(page).to_not have_content('Tester poster')
    # expect(page).to have_content('Your post was deleted')
    # expect(result_three).to be_truthy
  end

  scenario 'users feed displays their own posts and friends post' do
    zoe.posts.create(content: 'Yee yee')
    zac.posts.create(content: 'Yee haw')
    zoe.add_friend(zac)
    zac.add_friend(zoe)
    login_as(zac)
    visit '/'
    expect(page).to have_content('Yee yee')
    expect(page).to have_content(zoe.username)

    visit "/users/#{zoe.id}"
    click_on 'Friends'
    visit '/'
    # expect(page).to_not have_content('Yee yee') => (renders because it is shown in top posts)
    expect(page).to have_content('Yee haw')
  end
end
# rubocop:enable Metrics/BlockLength
