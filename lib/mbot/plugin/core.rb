module MBot
  require 'mbot/plugin/manager'
  require 'mbot/plugin/parent'
  class Plugin
    class << self
      def inherited klass
        MBot.plugin = { :class => klass }
      end
      def cmd trigger=nil
        MBot.plugin[:cmd] = trigger
      end
      def eval code
        module_eval code
      end
      def Plugin *arg
        Plugin
      end
      def class2name klass
        name = klass.respond_to?(:name) ? klass.name : klass.class.name
        name[klass.superclass.name + '::'] = ''
        name
      end
    end
  end
end
