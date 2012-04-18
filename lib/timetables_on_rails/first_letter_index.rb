module TimetablesOnRails
  class FirstLetterIndex
    def self.build_from_name users
      index = Hash.new
      users.each do |u|
        if index[u.name[0]]
          index[u.name[0]] << u
        else
          index[u.name[0]] = [u]
        end
      end
      index.sort { |v1, v2| v1[0] <=> v2[0] }
    end
  end
end
