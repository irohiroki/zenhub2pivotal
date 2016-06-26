require 'spec_helper'

describe Zenhub2pivotal::Issue do
  let(:issue) { Zenhub2pivotal::Issue.new(
    url: "https://api.github.com/repos/foo/bar/issues/1",
    repository_url: "https://api.github.com/repos/foo/bar",
    labels_url: "https://api.github.com/repos/foo/bar/issues/1/labels{/name}",
    comments_url: "https://api.github.com/repos/foo/bar/issues/1/comments",
    events_url: "https://api.github.com/repos/foo/bar/issues/1/events",
    html_url: "https://github.com/foo/bar/issues/1",
    id: 100000001,
    number: 1,
    title: "Title1",
    user: {
      login: "irohiroki",
    },
    labels: [
      {name: "baz"},
      {name: "qux"},
    ],
    state: "open",
    locked: false,
    assignee: {
      login: "irohiroki",
    },
    milestone: nil,
    comments: 0,
    created_at: Time.parse("2016-03-24T05:47:01Z"),
    updated_at: Time.parse("2016-03-24T05:47:01Z"),
    closed_at: nil,
    body: "Body1Line1\r\nLine2",
    'estimate' => {
      'value' => 3,
    },
  ) }

  describe '#csv' do
    subject { issue.csv(panel: 'current') }

    it 'retruns a line of csv' do
      expect(subject).to eq %|,Title1,"baz,qux",,,,,3,started,"Mar 3, 2016",,,irohiroki,"Body1Line1\r\nLine2",,irohiroki,\n|
    end
  end
end
