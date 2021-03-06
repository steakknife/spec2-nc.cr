require "spec2"
require "terminal-notifier"

module Spec2
  module Reporters
    class Nc
      include Spec2::Reporter

      ERROR_ICON = "\u26D4"
      SUCCESS_ICON = "\u2705"

      def initialize
        @errors = [] of Spec2::ExpectationNotMet
        @failed_examples = [] of Spec2::Example
      end

      def configure_output(@output); end
      def context_started(context); end
      def context_finished(context); end
      def example_started(example); end
      def example_succeeded(example); end

      def example_failed(example, exception)
        @errors << exception
        @failed_examples << example
      end

      def example_errored(example, exception)
        @errors << exception
        @failed_examples << example
      end

      def report
        title = project_name
        subtitle = "Finished in #{elapsed_time}"
        message = "#{SUCCESS_ICON} Success"

        if failed?
          message = "#{ERROR_ICON} #{failure_count} failed example"
          message += "s" if failure_count > 1
          message += "#{@failed_examples.first.description}"
        end

        notify(title, subtitle, message)
      end

      def project_name
        File.basename(File.expand_path("."))
      end

      private def notify(title : String, subtitle : String, message : String)
        TerminalNotifier.execute({ title: title, subtitle: subtitle, message: message })
      end

      private def failed?
        failure_count > 0
      end

      private def failure_count
        @errors.size
      end
    end
  end
end
