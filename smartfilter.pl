use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "0.1";

%IRSSI = (
	authors     => 'Christian Brassat',
	contact     => 'crshd@mail.com',
	name        => 'smartfilter.pl',
	description => 'This script hides join/part messages.',
	license     => 'BSD',
	url         => 'http://crshd.anapnea.net',
	changed     => '2012-10-02',
);

our $lastmsg = {};

sub smartfilter_chan {
	my ($server, $channel, $nick, $address) = @_;
	if ($lastmsg->{$nick} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
		Irssi::signal_stop();
	} else {
		$lastmsg->{$nick} = time();
	}
};

sub smartfilter_quit {
	my ($channel, $nick, $address, $reason) = @_;
	if ($lastmsg->{$nick} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
		Irssi::signal_stop();
	} else {
		$lastmsg->{$nick} = time();
	}
};

sub smartfilter_nick {
	my ($server, $newnick, $nick, $address) = @_;
	if ($lastmsg->{$nick} <= time() - Irssi::settings_get_int('smartfilter_delay')) {
		Irssi::signal_stop();
	} else {
		$lastmsg->{$nick} = time();
		$lastmsg->{$newnick} = time();
	}
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

Irssi::settings_add_int('smartfilter', 'smartfilter_delay', 300);
