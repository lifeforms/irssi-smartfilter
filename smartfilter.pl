use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "0.4";

%IRSSI = (
	authors     => 'Christian Brassat, Niall Bunting and Walter Hop',
	contact     => 'irssi-smartfilter@spam.lifeforms.nl',
	name        => 'smartfilter.pl',
	description => 'Improved smart filter for join, part, quit, nick messages',
	license     => 'BSD',
	url         => 'https://github.com/lifeforms/irssi-smartfilter',
	changed     => '2015-07-25',
);

# Associative array of nick => last active unixtime
our $lastmsg = {};
our $garbagetime = 1;

# Do checks after receving a channel event.
# - If the originating nick is not active, ignore the signal.
# - If nick is active, propagate the signal and display the event message.
#   Keep the nick marked as active, so we will not miss a re-join after a PART
#   or QUIT, a second nick change, etc.
sub checkactive {
	my ($nick, $altnick) = @_;
	if ($lastmsg->{$nick} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
		delete $lastmsg->{$nick};
		Irssi::signal_stop();
	} else {
		$lastmsg->{$nick} = time();
		if ($altnick) {
			$lastmsg->{$altnick} = time();
		}
	}

	# Run the garbage collection every interval.
	if ($garbagetime <= time() - (Irssi::settings_get_int('smartfilter_delay') * Irssi::settings_get_int('smartfilter_garbage_multiplier') )) {
		garbagecollect();
		$garbagetime = time();
	}
}

# Implements garbage collection.
sub garbagecollect{
	my ($key) = @_;
	foreach ($lastmsg->{$key}) {
		if ($lastmsg->{$key} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
                        delete $lastmsg->{$key}
		}
	}
}

# JOIN or PART received.
sub smartfilter_chan {
	my ($server, $channel, $nick, $address) = @_;
	&checkactive($nick, undef);
};

# QUIT received.
sub smartfilter_quit {
	my ($channel, $nick, $address, $reason) = @_;
	&checkactive($nick, undef);
};

# NICK change received.
sub smartfilter_nick {
	my ($server, $newnick, $nick, $address) = @_;
	&checkactive($nick, $newnick);
};

# Channel message received. Mark the nick as active.
sub log {
	my ($server, $msg, $nick, $address, $target) = @_;
	$lastmsg->{$nick} = time();
}

Irssi::signal_add('message public', 'log');
Irssi::signal_add('message join', 'smartfilter_chan');
Irssi::signal_add('message part', 'smartfilter_chan');
Irssi::signal_add('message quit', 'smartfilter_quit');
Irssi::signal_add('message nick', 'smartfilter_nick');

Irssi::settings_add_int('smartfilter', 'smartfilter_garbage_multiplier', 4);
Irssi::settings_add_int('smartfilter', 'smartfilter_delay', 1200);
