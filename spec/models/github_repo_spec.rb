require 'spec_helper'

describe GithubRepo do
  context 'validations' do
    it { should validate_presence_of(:programmer_id) }
    it { should validate_presence_of(:repo_owner) }
    it { should validate_presence_of(:repo_name) }
    it { should validate_presence_of(:default_branch) }
    it { should validate_uniqueness_of(:repo_name).scoped_to([:repo_owner, :programmer_id]) }
  end

  context 'default scope' do
    it 'should sort by shown, and then stars_count in descending order' do
      programmer = FactoryGirl.create(:programmer)
      repo1 = FactoryGirl.create(:github_repo, programmer: programmer, shown: false, stars_count: 15)
      repo2 = FactoryGirl.create(:github_repo, programmer: programmer, shown: true, stars_count: 2)
      repo3 = FactoryGirl.create(:github_repo, programmer: programmer, shown: false, stars_count: 2)
      repo4 = FactoryGirl.create(:github_repo, programmer: programmer, shown: true, stars_count: 5)
      repo5 = FactoryGirl.create(:github_repo, programmer: programmer, shown: false, stars_count: 0)
      programmer.github_repos.should eq([repo4, repo2, repo1, repo3, repo5])
    end
  end

  context 'qualify_programmer' do
    it 'should make programmer qualified if there are at least 25 stars' do
      repo = FactoryGirl.create(:github_repo, stars_count: 25)
      repo.programmer.qualified.should be_true
    end

    it 'should not make the programmer qualified if there are less than 25 stars' do
      repo = FactoryGirl.create(:github_repo, stars_count: 24)
      repo.programmer.qualified.should be_false
    end

    it 'should not fail if stars_count is nil' do
      repo = FactoryGirl.create(:github_repo, stars_count: nil)
      repo.programmer.qualified.should be_false
    end
  end
end
