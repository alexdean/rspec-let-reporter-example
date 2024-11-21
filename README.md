## Introduction

Sample test suite to demonstrate the usefulness of an rspec feature branch I'm experimenting with.

Some of the rspec test suites I work in are thousands of lines of code, with a given `let` value being defined & re-defined at many different levels. When troubleshooting, it can be extremely hard to determine whict version of a given `let` is actually in use in a particular test.

The patch here just prints out the file + line number where each `let` in use in a test was actually defined.

## Implementation

The patch is in https://github.com/alexdean/rspec-core/commit/bb7867b1491486117f1d87d680f160504fc947fb

## Usage

Check out this repo, then:

```
bundle
bin/rspec
```

## Example

For a spec file like this:

```ruby
# spec/test_spec.rb
require 'spec_helper'
require 'debug'

RSpec.describe 'things' do  
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
```

Will produce output like this:

```
$ bin/rspec

things
people: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:8
person_1: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:5
person_2: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:6
person_3: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:7
  top-level test
  context 1
people: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:8
person_1: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:5
person_2: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:20
person_3: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:7
    test 1
    context 2
people: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:8
person_1: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:32
person_2: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:20
person_3: /Users/alex/Code/rspec-let-reporter-example/spec/test_spec.rb:7
      test 2

Finished in 0.00384 seconds (files took 0.16579 seconds to load)
3 examples, 0 failures
```

## TODO

Things to fix before this would be ready for a real PR...

  1. It's a monkey patch. I didn't see a way to do this cleanly via `prepend`. I briefly tried to convert this to a `Refinement` but couldn't get the syntax right. Just went with a messy monkeypatch since this is just a demo at this point.
  2. I'm defining 2 methods instead of 1. Comments in the code describe what this is about. Again, this is the "just make something work" stage, to demonstrate the concept.
  3. I'd rather have the output after the test. That'll require storing the output somewhere. `puts` was much easier for this early stage.
  4. Would be nice to allow people to opt-in to this, via metadata or otherwise.
