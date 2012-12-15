# Check, Check, It

use checklists, like a boss

## Installation

    $ gem install checkcheckit

## TODO

- interactive run
  - socket.io between page and cmd line
- save a run
  - to file
  - to service
- resume a run
  - locally

- post to campfire

## Usage

### `list` the checklists

`checkcheckit` assumes a home directory of ~/checkcheckit

In that directory are folders for your organizations, groups, etc.

In those folders are your checklists.

A "checklist" is just a text file.
Every line that starts with a dash '-' is a step.
Everything beneath a step is that step's body or description.

    $ check list
    # Checklists
    heroku
      todo
    personal
      todo
    vault
      deploy

### `start` a checklist

You can go through a checklist by running `check start ` and then the checklist name.

If there are multiple checklists with the same name use the format `folder/checklist`.

When you iterate through a checklist you can just type "enter", "y", or "+" to confirm a step and "no" or "-" to
fail one.

You can always enter optional notes.

For example:

    $ check start deploy
    |-------| Step 1: Pull everything from git
      > git pull origin
    Check: <enter>
    Notes: <enter>

    |+------| Step 2: Make sure there are no uncommitted changes
      > `git status`
    Check: <n>
    Notes: <enter>

    |+------| Step 3: Diff master with heroku/master
      Make sure the change you want to push are what you're pushing
      > git fetch heroku
      > git diff heroku/master | $EDITOR
    Check: <y>
    Notes: <enter>

    |+-+----| Step 4: Run the test suite
    Check: failures!
    Notes: <enter>



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
