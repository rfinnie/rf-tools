#!/usr/bin/perl -w

use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.2";
%IRSSI = (
    authors     => 'Ryan Finnie',
    contact     => 'ryan@finnie.org',
    name        => 'Known Hosts',
    description => 'Tab complete against SSH known_hosts entries',
    license     => 'GPL2',
    url         => 'https://www.finnie.org/',
);

use Irssi qw/signal_add_last/;

Irssi::signal_add_last 'complete word' => sub {
  my ($complist, $window, $word, $linestart, $want_space) = @_;
  my $channel = $window->{'active'}->{'name'};

  # If the channel matches anything in the blacklist, immediately return.
  my @channel_blacklist = split(/[ ,]+/, Irssi::settings_get_str('knownhosts_channel_blacklist'));
  foreach my $check_channel (@channel_blacklist) {
    if(lc($check_channel) eq lc($channel)) { return; }
  }


  # If the whitelist exists, check it.  Only return if the channel does not
  # match anything in the whitelist.
  my @channel_whitelist = split(/[ ,]+/, Irssi::settings_get_str('knownhosts_channel_whitelist'));
  if(scalar(@channel_whitelist) > 0) {
    my($allowed) = 0;
    foreach my $check_channel (@channel_whitelist) {
      if(lc($check_channel) eq lc($channel)) { $allowed = 1; }
    }
    unless($allowed) { return; }
  }

  my $matchbase = Irssi::settings_get_bool('knownhosts_match_base_first');

  my @knownhosts_files = split(/[ ,]+/, Irssi::settings_get_str('knownhosts_files'));
  my @complist_toadd = ();

  foreach my $file (@knownhosts_files) {
    unless(open(FILE, $file)) { print "Cannot open $file: $!"; next };
    while(my $l = <FILE>) {
      # Only match SSH2 format entries
      next unless($l =~ /^([A-Za-z0-9\-\,\.\:]+)\s+ssh-/);
      foreach my $host (split(/,/, $1)) {
        # Ignore IPs
        next if($host =~ /^\d+\.\d+\.\d+\.\d+\$/);
        # Get the base hostname
        my($basehost) = $host;
        $basehost =~ s/\..*$//;

        if($matchbase && (substr($basehost, 0, length($word)) eq $word)) {
          # If the base hostname matches the tab completion, give them the
          # base hostname, not the FQDN.
          unless(grep $_ eq $basehost, @complist_toadd) {
            push(@complist_toadd, $basehost);
          }
        } elsif(substr($host, 0, length($word)) eq $word) {
          # If the FQDN (but not the base hostname above) matches the tab
          # tab completion, give them the FQDN.
          unless(grep $_ eq $host, @complist_toadd) {
            push(@complist_toadd, $host);
          }
        }

      }
    }
    close(FILE);
  }

  # Optionally sort the results (otherwise it should be in known_hosts
  # order).
  if(Irssi::settings_get_bool('knownhosts_sort_results')) {
    @complist_toadd = sort { lc($a) cmp lc($b) } @complist_toadd;
  }

  # Woot.
  push(@$complist, @complist_toadd);

};


# irssi config defaults
# (use /set [name] [value] rather than editing these directly)

# known_hosts files to load (comma/space-separated)
Irssi::settings_add_str('misc', 'knownhosts_files', '');
# Channel blacklist (comma/space-separated)
Irssi::settings_add_str('misc', 'knownhosts_channel_blacklist', '');
# Channel whitelist (comma/space-separated)
Irssi::settings_add_str('misc', 'knownhosts_channel_whitelist', '');
# Match a base hostname first, rather than the fqdn
# (adding the dot plus optionally some of the domain will match the FQDN)
Irssi::settings_add_bool('misc', 'knownhosts_match_base_first', 1);
# Sort the results alphanumerically
Irssi::settings_add_bool('misc', 'knownhosts_sort_results', 1);
