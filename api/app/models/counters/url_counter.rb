class Counters::UrlCounter
  class << self
    def instance
      @instance ||= Counter.find_by(name: "urls")
    end

    def increment!
      instance.with_lock do
        instance.increment!(:value)
      end
    end
  end
end
