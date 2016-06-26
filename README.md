# Zenhub2pivotal

A command line tool to generate CSV to migrate from ZenHub to Pivotal Tracker. Name all repo names in your ZenHub board and you get csv lines that suit to be imported to Pivotal Tracker.

## Installation

Assuming you have Ruby installed:

    $ gem install zenhub2pivotal

## Configuration

You need 3 things:

* GitHub Access Token
* ZenHub Access Token
* Pipeline-to-Panel mapping

All information should be in `.zenhub2pivotal.yml` in the working directory. Consult [.zenhub2pivotal.yml.sample](.zenhub2pivotal.yml.sample) regarding the format.

### GitHub Access Token

You can manage your access tokens in [Personal settings](https://github.com/settings/tokens) page in GitHub. [A detailed documentation](https://developer.github.com/v3/oauth/) is also available.

### ZenHub Access Token

Your ZenHub Access Token can be generated in [Settings](https://dashboard.zenhub.io/#/settings) page in ZenHub dashboard. See [the document](https://github.com/ZenHubIO/API#authentication) for more information.

### Pipeline-to-Panel mapping

In ZenHub you can create "Pipelines" and name them as you like, while Pivotal Tracker has 4 "Panels", whose names are fixed (Icebox, Backlog, Current, and Done). Zenhub2pivotal need to know which pipeline corresponds to which panel. The format looks like the following:

    "Wish List": icebox

In which case, all issues in Wish List pipeline will go into the Icebox. 4 panel names (`icebox`, `backlog`, `current`, and `done`) are keyword and must be accurate.

Only pipelines named in the configuration file will be processed.

## Usage

Give repository names as arguments.

    $ zenhub2pivotal your_org/repo1 [your_org/repo2 ...]

CSV lines should be out to the standard output.

## Limitation

### Comments

Issue comments are not supported.

### Issue order

Some issues might appear in a different position (order) in Pivotal Tracker. TODO: check Issue#<=>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/irohiroki/zenhub2pivotal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
