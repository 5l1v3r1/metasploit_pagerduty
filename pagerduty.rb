# -----------------------------------------------------------------------------
require 'pagerduty'
# -----------------------------------------------------------------------------
module Msf
  class Plugin::PagerDuty < Msf::Plugin

    class PagerDutyCommandDispatcher
      include Msf::Ui::Console::CommandDispatcher

      def name
        "pagerduty"
      end

      def commands
        {
          "pagerduty_key"  => "Set your service key for PagerDuty",
          "pagerduty_test" => "Test the PagerDuty integration"          
        }
      end

      def cmd_pagerduty_key(*args)
        self.framework.datastore['PAGERDUTY_KEY'] = args[0]
      end

      def cmd_pagerduty_test(*args)
        pagerduty_post("This was a test of your notification system.")
      end

      def pagerduty_post(message)
        pagerduty = Pagerduty.new(self.framework.datastore['PAGERDUTY_KEY'])
        incident = pagerduty.trigger(message)
      end
    end

    def method_missing(name, *args)
      if (self.framework.datastore['PAGERDUTY_DEBUG'] == "true")
        self.status("[DEBUG] Non-Reported (Method): #{name}(#{args.join(", ")})")
      end
      return
    end

    def pagerduty_post(message)
      pagerduty = Pagerduty.new(self.framework.datastore['PAGERDUTY_KEY'])
      incident = pagerduty.trigger(message)
      return
    end

    def on_session_open(session)
      pagerduty_post("There is an urgent alert for your pending action.")
      return
    end

    def initialize(framework, opts)
      super
      self.framework.events.add_session_subscriber(self)
      self.framework.datastore['PAGERDUTY_KEY']     = ""
      self.framework.datastore['PAGERDUTY_DEBUG']   = false
      add_console_dispatcher(PagerDutyCommandDispatcher)
      print_status("PagerDuty plugin loaded. Please configure your variables!")
    end

    def cleanup
      self.framework.events.remove_session_subscriber(self)
      remove_console_dispatcher(PagerDutyCommandDispatcher)
    end

    def name
      "pagerduty"
    end

    def desc
      "PagerDuty Notification on new sessions"
    end
  end
end
# -----------------------------------------------------------------------------
