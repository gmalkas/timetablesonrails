require_relative '../../../lib/timetables_on_rails/date_regroup.rb'

require 'ostruct'
require 'date'

module TimetablesOnRails
  describe DateRegroup do

    describe ".regroup_by_day" do
      let(:now) { DateTime.new 2011 }

      let(:resource_one) { OpenStruct.new(created_at: now) }
      let(:resource_two) { OpenStruct.new(created_at: now + 3) }
      let(:resource_three) { OpenStruct.new(created_at: now + 1) }
      let(:resource_four) { OpenStruct.new(created_at: now) }

      let(:resources) { 
        [resource_one, resource_two, resource_three, resource_four]
      }

      it "regroups the resources according to the day of creation" do
        result = { 
          now => Set.new([resource_one, resource_four]),
          now + 1 => Set.new([resource_three]),
          now + 3 => Set.new([resource_two])
        }

        DateRegroup.group_by_day(resources).should == result
      end
    end
     
  end
end
