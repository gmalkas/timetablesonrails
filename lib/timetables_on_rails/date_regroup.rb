module TimetablesOnRails
  class DateRegroup
    def self.group_by_day(resources)
      groups = Hash.new
      resources.each do |resource|
        if groups[resource.created_at.to_date]
          groups[resource.created_at.to_date] << resource
        else 
          groups[resource.created_at.to_date] = [resource]
        end
      end
      groups
    end
  end
end
