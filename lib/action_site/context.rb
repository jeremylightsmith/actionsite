module ActionSite
  class Context
    def method_missing(sym, *args)
      if sym.to_s.ends_with?("=") && args.size == 1
        metaclass.send(:attr_accessor, sym.to_s[0..-2].to_sym)
        send(sym, *args)
      else
        super
      end
    end

    private
  
    def metaclass 
      class << self; self; end # according to why...
    end
  end
end