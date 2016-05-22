# metasploit_pagerduty
Metasploit plugin for new sessions to hit a Pagerduty service.

## Installation

**Note: I don't include instructions for packaged Metasploit installations. I only run installations from source. User beware.**

First add the following line to the bottom of the Gemfile in the root MSF directory:

```
gem 'pagerduty'
```

Then issue the following command:

```
$ bundle install
```

This should install the `pagerduty` gem into your metasploit environment.

Now you can copy `pagerduty.rb` into the `plugins/` folder within the MSF root.

## Usage

To use the plugin, make sure you load it in metasploit:

```
msf> load pagerduty
```

Then, you'll want to set your service key:

```
msf> pagerduty_key YOUR_KEY_HERE
```

Then, you can fire off a test page by issuing:

```
msf> pagerduty_test
```

This should follow your escalation policies as intended.

