# Check, Check, It

use checklists, like a boss

## Installation

    $ gem install checkcheckit

## TODO

- resume a run
  - locally from URL

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

### Live mode

This is fun.

`check start <listname> --live` will create an _interactive_ companion URL on the web.

This URL is websockets-enabled and communicates with the command line.
This means command line 'checks' get pushed to the web.  Once a list is on the web you can
disconnect the command line and continue finishing it (with others).

    $ check start deploy --live
    Live at URL: http://checkcheckit.herokuapp.com/4f24b9d933d5467ec913461b8da3f952dbe724cb
    Websocket refused connection - using POST
    |........| Step 1: Make sure there are no uncommitted changes
      > `git status`
    Check:

    |+.......| Step 2: Pull everything from git
      > `git pull`
    Check: ^C
    bye

During that console session the web UI would be interactively crossing items off the list:
<img height="400px" src="http://f.cl.ly/items/1h3V0L1a1p1a062I2X3f/Screen%20Shot%202012-12-16%20at%209.37.56%20PM.png" />

### Email
Specify an email (or a comma-separated list) on the command line via the `--email` flag and
the address(es) will receive an email with a link to a web version of the checklist.


    $ check start deploy --email bob@work.com,steve@work.com
    Live at URL: http://checkcheckit.herokuapp.com/4f24b9d933d5467ec913461b8da3f952dbe724cb
    Websocket refused connection - using POST
    |........| Step 1: Make sure there are no uncommitted changes
      > `git status`
    Check: ^C
    bye

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
