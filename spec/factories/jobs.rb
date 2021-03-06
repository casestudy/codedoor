FactoryGirl.define do
  factory :job_from_direct_contact, aliases: [:job] do
    client
    programmer
    hourly_rate 50
    availability 'full-time'
    sequence :name do |n|
      "Test Job #{n}"
    end
    rate_type 'hourly'
    before :create do |instance|
      instance.started_at = 1.day.ago if (instance.running? || instance.finished? || instance.disabled?)
      instance.finished_at = 1.day.ago if (instance.finished? || instance.disabled?)
    end
  end
end
