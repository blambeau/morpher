class Ducktrap
  # Abstract ducktrap that delegates a single ducktrap
  module Unary 

    module InstanceMethods

      # Return result for input
      #
      # @param [Object] input
      #
      # @return [Result]
      #
      # @api private
      #
      def run(input)
        result_klass.new(self, input)
      end

      # Return ducktrap
      #
      # @return [Ducktrap]
      #
      # @api private
      #
      attr_reader :operand

      # Perform pretty dump
      #
      # @return [self]
      #
      # @api private
      #
      def pretty_dump(output=Formatter.new)
        output.name(self)
        output.nest('operand:', operand)
        self
      end

    private

      # Initialize object
      #
      # @param [Ducktrap] operand
      #
      # @api private
      #
      def initialize(operand)
        @operand = operand
        super()
      end
    end

    module ClassMethods
      def build(*args, &block)
        postprocessor = Noop.instance

        if block
          postprocessor = Ducktrap::Block.build(&block)
        end

        new(postprocessor, *args)
      end
    end

    def self.included(scope)
      scope.send(:include, InstanceMethods)
      scope.extend(ClassMethods)
    end

    class Result < Ducktrap::Result

      # Return operand
      #
      # @return [Ducktrap]
      #
      # @api private
      #
      def operand
        context.operand
      end

      # Initialize object
      #
      # @param [Ducktrap] context
      # @param [Object] input
      #
      def initialize(context, input)
        super(context, input)
      end
    end
  end
end