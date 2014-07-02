# Check, Check, It

checkcheckit is a ruby gem that provides a `check` binary that lets you run
through simple, text-based checklists with a step-by-step prompt.

You also get a web-based interface that lets you collaborate on your checklist
progress with friends or coworkers.

## Installation

    $ gem install checkcheckit

## Usage

A checklist is just a text file that supports a subset of Markdown formatting.
Every line that starts with a `-` is a step.
Everything beneath a step is that step's body or description.

Here's an example checklist:

    $ cat sandwich.md
    - Buy the ingredients.
        Make sure the bread is fresh and soft, and the peanut butter should be
        organic for best results.
    - Apply the peanut butter.
        Do this evenly on both slices of bread.
    - Apply the jelly.
        Use 1-2oz, measured with a home scale.
    - Close sandwich.
    - Eat.

When you want to make a sandwich, start the checklist with `check start`:

    $ check start sandwich.md
    |.....| Step 1: Buy the ingredients.
      Make sure the bread is fresh and soft, and the peanut butter should be
      organic for best results.
    Check:

    |+....| Step 2: Apply the peanut butter.
      Do this evenly on both slices of bread.
    Check:

    |++...| Step 3: Apply the jelly.
      Use 1-2oz, measured with a home scale.
    Check:

    |+++..| Step 4: Close sandwich.
    Check:

    |++++.| Step 5: Eat.
    Check:

    |+++++| Done

You can now make a sandwich the same way every time.

## Advanced usage

### shell out to commands

This is useful.

`check` will recognize any text that is surrounded with backticks:
\`command with args\` as a command to potentially run.

It will prompt you if you'd like to run the command. You will then have the
option to check it off if the output looks correct to you.

For example:

    $ cat hello.txt
    - say hello
        `echo hello`

    $ check start hello.txt
    |.| Step 1: say hello
        `echo hello`

    Run command `echo hello`?
    <enter>,y,n:
    running `echo hello`
    hello
    Check:

    |+| Done

### Centralized checklists

You can put all of your checklists into `~/checkcheckit`, and start them with
shorthand form. If there are multiple checklists with the same name use the
format `folder/checklist`.

List your checklists
    $ check list
    # Checklists
    personal
      groceries
    work
      deploy

Start with shortcut names
    $ check start groceries

One great use case is to create a git repository of checklists for your team.
    $ mkdir -p ~/src/team/checklists
    $ cd ~/src/team/checklists
    $ git init
    $ vim deploy.md && git commit -a -m "first checklist"
    $ mkdir -p ~/checkcheckit
    $ ln -s ~/src/team/checklists ~/checkcheckit/team
    $ check list
    # Checklists
    team
      deploy        # Deploy the app

### Options

#### `--live` mode

This is fun.

`check start <listname> --live` will create an _interactive_ companion URL on the web.

This URL is websockets-enabled and communicates with the command line.
This means command line 'checks' get pushed to the web. Once a list is on the web you can
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

#### `--web-only`, `--open`, `--no-cli`

Start a list, open it in your browser, and skip the CLI interaction
    $ check start groceries --live --web-only --open
    $ check start groceries --live --no-cli -O
    Live at URL: http://checkcheckit.herokuapp.com/4f24b9d933d5467ec913461b8da3f952dbe724cb

Run commands from the checklist
    $ cat ./hello.txt
    - say hello
        `echo hello`

    $ check start ./hello.txt
    |.| Step 1: say hello
        `echo hello`

    Run command `echo hello`?
    <enter>,y,n:
    running `echo hello`
    hello
    Check:

    |+| Done

When you iterate through a checklist you can just type "enter", "y", or "+" to confirm a step and "no" or "-" to
fail one.

#### `--open/-O`

`check start <listname> --live -O/--open` will open the url in your browser by shelling out to `open`

#### `--email <address(es)>`
Specify an email (or a comma-separated list) on the command line via the `--email` flag and
the address(es) will receive an email with a link to a web version of the checklist.


    $ check start deploy --email bob@work.com,steve@work.com
    Live at URL: http://checkcheckit.herokuapp.com/4f24b9d933d5467ec913461b8da3f952dbe724cb
    Websocket refused connection - using POST
    |........| Step 1: Make sure there are no uncommitted changes
      > `git status`
    Check: ^C
    bye

## TODO

- resume a run locally from URL
- push notes to web
- emit pass/fail and colorize
- post to campfire

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
