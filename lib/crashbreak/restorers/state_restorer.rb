module Crashbreak
  class StateRestorer
    def initialize(error_id)
      @error_id = error_id
    end

    def restore
      {}.tap do |restorers_hash|
        restorers.each do |restorer|
          restorers_hash[key_name(restorer)] = restorer.new(dumper_data(restorer)).restore
        end
      end
    end

    private

    def dumpers_data
      @dumpers_data ||= Crashbreak::DumpersDataRepository.new(@error_id).dumpers_data
    end

    def restorers
      dumpers_data.keys.map {|dumper_name| restorer_class_by_dumper_name(dumper_name)}
    end

    def restorer_class_by_dumper_name(dumper_name)
      dumper_name.gsub('Dumper', 'Restorer').constantize
    end

    def dumper_data(restorer)
      dumper_name = restorer.to_s.gsub('Restorer', 'Dumper')
      dumpers_data[dumper_name].merge('error_id' => @error_id)
    end

    def key_name(restorer)
      restorer.to_s.gsub('Crashbreak::', '').gsub('Restorer', '').underscore.to_sym
    end
  end
end