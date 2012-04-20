module TimetablesOnRails
  class FirstLetterIndex
    def self.build_from_name users
      users.to_set.classify { |user| user.name[0] }.sort { |v1, v2| v1[0] <=> v2[0] }
    end
  end
end
