module StorageSupport
  attr_accessor :uuid, :updated_at
  
  def initialize(*)
    @uuid = SecureRandom.hex
    @updated_at = Time.now
  end
  
  def update(params)
    params.map do |attribute, value|
      public_send :"#{attribute}=", value
    end
    
    self.updated_at = Time.now
  end
  
  def self.included(base)
    base.extend ClassModules
  end
  
  module ClassModules
    attr_accessor :all
    
    def all
      @all ||= []
    end
    
    def count
      all.count
    end
    
    def blank?
      count === 0
    end
    
    def <<(record)
      all << record
    end
    
    def first
      all[0]
    end
    
    def last
      all[-1]
    end
    
    def find(params)
      all.find { |record| match_with_and(record, params) }
    end
    
    def where(params)
      record_collection_proxy     = self.dup
      record_collection_proxy.all = all.select { |record| match_with_and(record, params) }
      
      record_collection_proxy
    end
    
    def create(params = {})
      all << _record = new(params)
      
      _record
    end
    
    private
      
      def match_with_and(record, params)
        params.all? { |param, value| record.public_send(param) == value }
      end
  end
end
