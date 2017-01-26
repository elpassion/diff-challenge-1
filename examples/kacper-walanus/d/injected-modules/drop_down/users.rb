require_relative '../drop_down'

module DropDown
  module Data
    class Users
      def initialize(ui:, user:, locale:, teams_drop_down_value:)
        @ui = ui
        @user = user
        @locale = locale
        @teams_drop_down_value = teams_drop_down_value
      end

      def locale
        @locale
      end

      def title_key
        'employees'
      end

      def title
        @ui.new(self).title
      end

      def options
        case @teams_drop_down_value
          when :managers then managers_options
          else
            []
        end
      end

      private

      def managers_options
        @ui.new(self).options_wrapper do
          managers.map do |manager|
            OpenStruct.new( name: manager[:name], value: manager[:id] )
          end
        end
      end

      def managers
        # @user.managers
        [
          { name: 'President', id: 1 },
          { name: 'Vice President', id: 2 },
        ]
      end
    end
  end
end
