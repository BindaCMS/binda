require "test_helper"

describe MaintenanceController do
  it "should get index" do
    get maintenance_index_url
    value(response).must_be :success?
  end

end
