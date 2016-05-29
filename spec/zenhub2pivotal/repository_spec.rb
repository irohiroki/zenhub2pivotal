require 'spec_helper'
require 'webmock'

describe Zenhub2pivotal::Repository do
  before { allow(Zenhub2pivotal::Config).to receive(:all).and_return({}) }
  let(:repository) { Zenhub2pivotal::Repository.new('foo/bar') }

  describe '#issues' do
    subject { repository.issues }
    before do
      WebMock.stub_request(:get, "https://api.github.com/repos/foo/bar/issues").to_return(
        headers: { 'Link' => '<https://api.github.com/repos/foo/bar/issues?page=2&per_page=2>; rel="next"' },
        body: JSON.parse(File.read(File.expand_path('../../fixtures/issues1.json', __FILE__))),
      )
      WebMock.stub_request(:get, "https://api.github.com/repos/foo/bar/issues?page=2&per_page=2").to_return(
        body: JSON.parse(File.read(File.expand_path('../../fixtures/issues2.json', __FILE__))),
      )
    end

    it 'returns issue objects' do
      expect(subject).to contain_exactly(
        an_instance_of(Zenhub2pivotal::Issue),
        an_instance_of(Zenhub2pivotal::Issue),
        an_instance_of(Zenhub2pivotal::Issue),
      )
    end
  end
end
