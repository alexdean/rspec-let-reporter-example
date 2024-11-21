## Introduction

Sample test suite to demonstrate the usefulness of an rspec feature branch I'm experimenting with.

Some of the rspec test suites I work in are thousands of lines of code, with a given `let` value being defined & re-defined at many different levels. When troubleshooting, it can be extremely hard to determine whict version of a given `let` is actually in use in a particular test.

The patch here just prints out the file + line number where each `let` in use in a test was actually defined.

Shortcomings:

  1. It's a monkey patch. I didn't see a way to do this cleanly via `prepend`. I briefly tried to convert this to a `Refinement` but couldn't get the syntax right. Just went with a messy monkeypatch since this is just a demo at this point.
  2. I'm defining 2 methods instead of 1. Comments in the code describe what this is about. Again, this is the "just make something work" stage, to demonstrate the concept.
  3. I'd rather have the output after the test. That'll require storing the output somewhere. `puts` was much easier for this early stage.
  4. Would be nice to allow people to opt-in to this, via metadata or otherwise.

## Usage

Check out this repo, then:

```
bundle
bin/rspec
```

## Sample Output

```
$ bin/rspec

Randomized with seed 29263

things
people: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:75
person_1: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:71
person_2: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:73
person_3: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:74
  top-level test
  context 1
people: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:75
person_1: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:71
person_2: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:87
person_3: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:74
    test 1
    context 2
people: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:75
person_1: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:99
person_2: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:87
person_3: /Users/alex/Code/rspec-let-insights/spec/test_spec.rb:74
      test 2

Finished in 0.00454 seconds (files took 0.19059 seconds to load)
3 examples, 0 failures
```
