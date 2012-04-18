require_relative '../../../lib/timetables_on_rails/first_letter_index'

require 'ostruct'

module TimetablesOnRails
  describe FirstLetterIndex do
    describe ".build_from_name" do
      it "returns users indexed by the first letter of their name and sorts them" do
        bertier = OpenStruct.new name: "Bertier"
        malkas = OpenStruct.new name: "Malkas"
        marchand = OpenStruct.new name: "Marchand"

        index = {
          'B' => [bertier],
          'M' => [malkas, marchand]
        }

        FirstLetterIndex.build_from_name [bertier, malkas, marchand]
      end
    end
  end
end
