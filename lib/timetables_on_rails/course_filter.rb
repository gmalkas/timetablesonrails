module TimetablesOnRails
  class CourseFilter
    def self.by_status(courses)
      courses.to_set.classify { |course| course.status }
    end

    def self.by_manager(courses)
      courses.to_set.classify { |course| course.manager }
    end
  end
end
