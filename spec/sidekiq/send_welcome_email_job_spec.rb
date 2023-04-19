require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
RSpec.describe SendWelcomeEmailJob, type: :job do
  it  "exists and queues jobs" do 
    job = SendWelcomeEmailJob.new
   
    expect(job).to be_a(SendWelcomeEmailJob)

    SendWelcomeEmailJob.perform_async
    expect(SendWelcomeEmailJob.jobs.count).to eq(3)

    SendWelcomeEmailJob.perform_async
    expect(SendWelcomeEmailJob.jobs.count).to eq(4)
  end
end
