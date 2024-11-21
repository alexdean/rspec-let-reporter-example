require 'spec_helper'
require 'debug'

# module LetReporter
#   refine RSpec::Core::MemoizedHelpers::ClassMethods do
# end

# module RSpec::Core::MemoizedHelpers
#   using LetReporter
# end

# module RSpec::Core::MemoizedHelpers::ClassMethods
#   def let(name, &block)
#     # We have to pass the block directly to `define_method` to
#     # allow it to use method constructs like `super` and `return`.
#     raise "#let or #subject called without a block" if block.nil?

#     # A list of reserved words that can't be used as a name for a memoized helper
#     # Matches for both symbols and passed strings
#     if [:initialize, :to_s].include?(name.to_sym)
#       raise ArgumentError, "#let or #subject called with reserved name `#{name}`"
#     end

#     our_module = MemoizedHelpers.module_for(self)

#     # If we have a module clash in our helper module
#     # then we need to remove it to prevent a warning.
#     #
#     # Note we do not check ancestor modules (see: `instance_methods(false)`)
#     # as we can override them.
#     if our_module.instance_methods(false).include?(name)
#       our_module.__send__(:remove_method, name)
#       our_module.__send__(:remove_method, "__#{name}_main")
#     end

#     our_module.__send__(:define_method, "__#{name}_main", &block)
#     defined_at = caller_locations[0]
#     our_module.__send__(:define_method, name) do
#       puts "#{name}: #{defined_at.path}:#{defined_at.lineno}"
#       send("__#{name}_main")
#     end

#     # If we have a module clash in the example module
#     # then we need to remove it to prevent a warning.
#     #
#     # Note we do not check ancestor modules (see: `instance_methods(false)`)
#     # as we can override them.
#     if instance_methods(false).include?(name)
#       remove_method(name)
#     end

#     # Apply the memoization. The method has been defined in an ancestor
#     # module so we can use `super` here to get the value.
#     if block.arity == 1
#       define_method(name) { __memoized.fetch_or_store(name) { super(RSpec.current_example, &nil) } }
#     else
#       define_method(name) { __memoized.fetch_or_store(name) { super(&nil) } }
#     end
#   end
# end

RSpec.describe 'things' do  
  
  # when `let(:person1)` is called, a `person_1` method is defined in 2 places: 
  # 
  # 1. in `RSpec::ExampleGroups::Things::Context1::LetDefinitions#person_1`
  #    the block we provide becomes the body of the defined method.
  # 2. in `RSpec::ExampleGroups::Things::Context1#person_1`
  #    this provides memoization. it calls the inner `LetDefinitions#person_1`
  #    first and then returns that same value on subsequent calls.
  let(:person_1) { 'p1 from top level' }

  let(:person_2) { 'p2 from top level' }
  let(:person_3) { 'p3 from top level' }
  let(:people) { [ person_1, person_2, person_3 ] }

  example 'top-level test' do
    expect(people).to eq([person_1, person_2, person_3])
    expect(people).to eq([
      'p1 from top level', 
      'p2 from top level', 
      'p3 from top level', 
    ])
  end

  describe 'context 1' do
    let(:person_2) { 'p2 from context 1' }

    example 'test 1' do
      expect(people).to eq([person_1, person_2, person_3])
      expect(people).to eq([
        'p1 from top level', 
        'p2 from context 1', 
        'p3 from top level', 
      ])     
    end

    describe 'context 2' do
      let(:person_1) { 'p1 from context 2'}

      example 'test 2' do
        expect(people).to eq([person_1, person_2, person_3])

        expect(people).to eq([
          'p1 from context 2', 
          'p2 from context 1', 
          'p3 from top level', 
        ])
      end
    end
  end
end
