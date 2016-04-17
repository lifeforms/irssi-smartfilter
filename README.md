irssi-smartfilter
=================

This script filters JOIN, PART, QUIT and NICK event messages to active users only.

When the script is running, a user's events will only be displayed when they have been active recently. If the user is not active in the channel, their events will be ignored.

This script limits noise from large channels, while preventing you from talking to a conversation partner who has left (which can happen if you just ignore all events).

By default, a user is considered active if they have said something in the last 20 minutes. If they leave the channel, change nick etc., they are kept active, so you will not miss re-joins or subsequent nick changes.

## Usage
- Download `smartfilter.pl` to your `.irssi/scripts` directory
- To run once: `/run smartfilter`
- To run automatically, create a symlink to `smartfilter.pl` in your `.irssi/scripts/autorun` directory

## Optional configuration
- You can specify a space-separated list of channels for which the filtering will be disabled: `/set smartfilter_ignored_chans #channel1 #channel2`
- You can change the recent activity time (in seconds): `/set smartfilter_delay 1200`
- Old nicks are removed from memory periodically. You can change how often the garbage collection runs by picking after how many smartfilter-delays it runs: `/set smartfilter_garbage_multiplier 4`

## Contributors
[Christian Brassat](http://crshd.anapnea.net/2012/10/03/Smartfilter-for-Irssi/), [Niall Bunting](http://niallbunting.com/), [Walter Hop](https://lifeforms.nl/) and [Frantisek Sumsal](https://github.com/mrc0mmand)
