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
