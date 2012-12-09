# Check, Check, It

use checklists, like a boss

## Installation

    $ gem install checkcheckit

## Usage


### List the Checklists

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

### start a checklist

You can go through a checklist by running `check start ` and then the checklist name.

(NIY - Not Implemented Yet)
If there are multiple checklists with the same name use the format `folder/checklist`.

When you iterate through a checklist you can just type "enter", "y", or "+" to confirm a step.

A "no", "-", or body of text (body of text NIY) is considered a failed step.
The body of text is for describing what went wrong.

For example:

    $ check start deploy
    |-------| Step 1: Pull everything from git
      > git pull origin
    Check: <enter>

    |+------| Step 2: Make sure there are no uncommitted changes
      > `git status`
    Check: <n>

    |+------| Step 3: Diff master with heroku/master
      Make sure the change you want to push are what you're pushing
      > git fetch heroku
      > git diff heroku/master | $EDITOR
    Check: <y>

    |+-+----| Step 4: Run the test suite
    Check: failures!



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
