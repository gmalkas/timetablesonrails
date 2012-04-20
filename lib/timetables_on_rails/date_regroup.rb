module TimetablesOnRails
  class DateRegroup
    def self.group_by_day(resources)
      resources.to_set.classify { |resource| resource.created_at.to_date }
    end
  end
end
