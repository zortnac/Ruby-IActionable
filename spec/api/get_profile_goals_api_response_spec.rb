require 'spec_helper.rb'

describe "API response to get_profile_goals" do
  before do
    @sample_response = {
        "Available" => [
            {
                "Key" => "hard_goal",
                "Description" => "Do something hard 10 times within a week and earn 200 points",
                "Name" => "Hard Goal",
                "Interval" => "Weekly",
                "Progress" => [
                    {
                        "ConditionMetDate" => nil,
                        "CurrentValue" => 9,
                        "Description" => "Do something hard 10 times",
                        "RequiredValue" => 10
                    }
                ]
            }
        ],
        "Completed" => [
            {
                "Key" => "easy_goal",
                "Description" => "Do something easy 5 times today and earn 100 points",
                "Name" => "Easy Goal",
                "Interval" => "Daily",
                "Progress" => [
                    {
                        "ConditionMetDate" => "/Date(1275706032317-0600)/",
                        "CurrentValue" => 5,
                        "Description" => "Do something easy 5 times",
                        "RequiredValue" => "5"
                    }
                ],
                "AwardDate" => "/Date(1275706032317-0600)/"
            }
        ]
    }
  end
  
  it "should not raise error on wrapping in an object" do
    lambda { IActionable::Objects::ProfileGoals.new(@sample_response) }.should_not raise_error
  end
  
  describe "when wrapped in an object" do
    before do
      @wrapped = IActionable::Objects::ProfileGoals.new(Marshal.load(Marshal.dump(@sample_response)))
    end
    
    it "should contain ar array of available goals" do
      @wrapped.available.should be_instance_of Array
      @wrapped.available.first.key.should == @sample_response["Available"][0]["Key"]
      @wrapped.available.first.description.should == @sample_response["Available"][0]["Description"]
      @wrapped.available.first.name.should == @sample_response["Available"][0]["Name"]
      @wrapped.available.first.interval.should == @sample_response["Available"][0]["Interval"]
      @wrapped.available.first.award_date.should be_nil
    end
    
    it "should contain an array of progresses within each available goals" do
      @wrapped.available.first.progress.should be_instance_of Array
      @wrapped.available.first.progress.first.condition_met_date.should be_nil
      @wrapped.available.first.progress.first.current_value.should == @sample_response["Available"][0]["Progress"][0]["CurrentValue"]
      @wrapped.available.first.progress.first.description.should == @sample_response["Available"][0]["Progress"][0]["Description"]
      @wrapped.available.first.progress.first.required_value.should == @sample_response["Available"][0]["Progress"][0]["RequiredValue"]      
    end
    
    it "should contain ar array of completed goals" do
      @wrapped.completed.should be_instance_of Array
      @wrapped.completed.first.key.should == @sample_response["Completed"][0]["Key"]
      @wrapped.completed.first.description.should == @sample_response["Completed"][0]["Description"]
      @wrapped.completed.first.name.should == @sample_response["Completed"][0]["Name"]
      @wrapped.available.first.interval.should == @sample_response["Available"][0]["Interval"]
      @wrapped.completed.first.award_date.should_not be_nil
    end
    
    it "should contain an array of progresses within each completed goals" do
      @wrapped.completed.first.progress.should be_instance_of Array
      @wrapped.completed.first.progress.first.condition_met_date.should_not be_nil
      @wrapped.completed.first.progress.first.current_value.should == @sample_response["Completed"][0]["Progress"][0]["CurrentValue"]
      @wrapped.completed.first.progress.first.description.should == @sample_response["Completed"][0]["Progress"][0]["Description"]
      @wrapped.completed.first.progress.first.required_value.should == @sample_response["Completed"][0]["Progress"][0]["RequiredValue"]      
    end
    
    it "should convert to a hash equal to the original" do
      hash_including(@sample_response).should == @wrapped.to_hash
    end
  end
end