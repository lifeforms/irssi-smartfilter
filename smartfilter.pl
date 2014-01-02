use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "0.2";

%IRSSI = (
	authors     => 'Christian Brassat and Walter Hop',
	contact     => 'irssi-smartfilter@spam.lifeforms.nl',
	name        => 'smartfilter.pl',
	description => 'Smart filter for join, part, quit, nick messages',
	license     => 'BSD',
	url         => 'https://github.com/lifeforms/irssi-smartfilter',
	changed     => '2014-01-02',
);

our $lastmsg = {};

sub checkactive {
	my ($nick, $altnick) = @_;
	if ($lastmsg->{$nick} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
		Irssi::signal_stop();
	} else {
		$lastmsg->{$nick} = time();
		if ($altnick) {
			$lastmsg->{$altnick} = time();
		}
	}
}

sub smartfilter_chan {
	my ($server, $channel, $nick, $address) = @_;
	&checkactive($nick, undef);
};

sub smartfilter_quit {
	my ($channel, $nick, $address, $reason) = @_;
	&checkactive($nick, undef);
};

sub smartfilter_nick {
	my ($server, $newnick, $nick, $address) = @_;
	&checkactive($nick, $newnick);
};

sub log {
	my ($server, $msg, $nick, $address, $target) = @_;
	$lastmsg->{$nick} = time();
}

Irssi::signal_add('message public', 'log');
Irssi::signal_add('message join', 'smartfilter_chan');
Irssi::signal_add('message part', 'smartfilter_chan');
Irssi::signal_add('message quit', 'smartfilter_quit');
Irssi::signal_add('message nick', 'smartfilter_nick');

Irssi::settings_add_int('smartfilter', 'smartfilter_delay', 900);
