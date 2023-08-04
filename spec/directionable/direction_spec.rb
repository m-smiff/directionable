# frozen_string_literal: true

RSpec.describe Directionable::Direction do
  # # Boundary Contexts
  # shared_context '@degrees == 0' do
  #   let(:degrees) { 0 }
  # end

  # shared_context '@degrees == 361' do
  #   let(:degrees) { 361 }
  # end
  # # End of Boundary Contexts

  # # Normal Contexts
  # shared_context '@degrees == 180' do
  #   let(:degrees) { 180 }
  # end

  # shared_context '@degrees == 360' do
  #   let(:degrees) { 360 }
  # end
  # # End of Normal Contexts

  # shared_examples 'it interpolates in to string' do |asserted_degrees|
  #   it { expect(subject).to eq "#{asserted_degrees}#{Directionable::DEGREES_SYMBOL}" }
  # end

  # describe '#to_s' do
  #   subject { described_class.new(degrees).to_s }

  #   include_context '@degrees == 0' do
  #     it_behaves_like 'it interpolates in to string', 360
  #   end

  #   include_context '@degrees == 180' do
  #     it_behaves_like 'it interpolates in to string', 180
  #   end

  #   include_context '@degrees == 360' do
  #     it_behaves_like 'it interpolates in to string', 360
  #   end

  #   include_context '@degrees == 361' do
  #     it_behaves_like 'it interpolates in to string', 1
  #   end
  # end

  # describe '#compass_point' do
  #   subject { described_class.new(degrees).compass_point }

  #   include_context '@degrees == 0' do
  #     it { is_expected.to be :N }
  #   end
  # end
end
