module MBot
  class PluginManager

    attr_accessor :plugin, :bot
    def initialize bot=nil
      @bot    = bot
      @plugin = {}
    end

    def load plugin
      if @plugin[plugin]
        Log.info "#{plugin} already loaded"
        return [:already_loaded, plugin] 
      end
      status = [:undefined, plugin]
      file = File.join CFG.plugin[:dir], plugin.to_s + '.rb'
      begin
        const = { Object => Object.constants, Plugin => Plugin.constants }
        MBot::Plugin.eval File.read file
        const = { Object => Object.constants - const[Object], 
                  Plugin => Plugin.constants - const[Plugin] }
        status = setup_plugin plugin, const
      rescue Exception => e
        status = [:rescue, file]
        Log.error "#{plugin}: #{e.backtrace}"
        raise ## for plugin debugging
      end
      status
    end

    def unload plugin
      if (status = @plugin.delete plugin)
        status[:const].each do |klass, consts|
          # not safe (plug1 defines FOO, plug2 uses it, plug1 unloads and FOO is gone)
          # but we do it anyhow, plug is supposed to be simple and not hit above issue
          consts.each { |const| klass.send :remove_const, const }
        end
        status[:io].each { |io| (io.close unless io.closed?) if io.respond_to? :closed? }
        [:ok, plugin]
      else
        [:noplugin, plugin]
      end
    end

    def key_by_class klass
      k = @plugin.find { |name, p| p[:class] == klass }
      k.first if k
    end

    def io plug
      @plugin[key_by_class(plug)][:io]
    end

    private

    def setup_plugin plugin, const
      unless MBot.plugin
        Log.warn  "#{plugin} did not populate MBot.plugin"
        return [:no_plugin, file] 
      end
      klass, MBot.plugin[:class] = MBot.plugin[:class], nil
      @plugin[plugin] = {
        :class     => klass,
        :cmd       => resolve_cmd(klass),
        :io        => [],
        :const     => const,
      }
      # instantiate only after hash is created
      @plugin[plugin][:instance] = klass.send :new, @bot
      [:ok]
    end

    def resolve_cmd klass
      cmd = (MBot.plugin[:cmd] or Plugin.class2name klass)
      [cmd].flatten.map do |e|
        if e.class == String
          /^\s*#{e}(?:\s+|$)/i
        elsif e.class == Regexp
          e
        end
      end.compact
    end

  end
end
