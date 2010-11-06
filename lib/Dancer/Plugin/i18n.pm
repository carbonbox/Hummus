package Dancer::Plugin::i18n;

=head1 NAME

Dancer::Plugin::i18n - Internationalization plugin for Dancer

=head1 SYNOPSIS

use Dancer;
use Dancer::Plugin::i18n;

# set the language
language qw/en-US en/;

# get strings/en-US/greetings.yml
my $msg = message greetings => 'hello';

=cut

use 5.10.0;
use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin;
use YAML ();

our $VERSION = '0.01';
my $settings = plugin_setting;
my $messages = {};

=head1 METHODS

=head2 language

  # set specific language
  language 'en-GB';

  # or set it to the first available
  language qw/en-GB en-US en/;

Sets the language. This can also be set
in config.yml, but is probably more interesting
if it is set dynamically based on user preferences
of HTTP request. If none of the languages are
available, it will fall back on the default
value. It returns the actual language set to.
If there are no arguments, it will just return
the language it is set to.

=cut

register language => sub {
    my (@languages) = @_;

    for my $lang (@languages) {
        last $settings->{language} = $lang if has_language($lang);
    }
    return $settings->{language} || $settings->{default};
};

=head2 message

  # get a message from a message set
  print (message msg_set => 'message');

Returns the message in the current language. The first
argument is the The message
is retrieved from the 'strings' directory by default

=cut

register message => sub {
    my ($set, $label) = @_;
    my $lang = $settings->{language} || $settings->{default};
    cache($lang, $set);
    return $messages->{$lang}{$set}{$label} // '[$lang $set $label]';
};

=head2 strings

  # get all the strings from a set
  my $strings = strings 'greetings';

  # or just get a subset
  my $subset = strings errors => 'login';

Returns the full hash of strings from a set or subset.
This is useful to pass to a template that might need a
bunch of lacalized strings.

=cut

register strings => sub {
    my ($set, @subset) = @_;
    my $lang = $settings->{language} || $settings->{default};
    cache($lang, $set);

    # drill down
    my $subset = $messages->{$lang}{$set};
    for my $item (@subset) {
        return {} unless $subset;
        $subset = $subset->{$item}
    }
    return $subset || {};
};

=head2 has_language

  if (has_language('en-US')) {
      print "English is supported!";
  }

Checks if a directory for the language exists.

=cut

sub has_language {
    my ($lang) = @_;
    return -d path(root(), $lang);
}

=head2 root

  my $path = root();

Gets the localized strings path.

=cut

sub root {
    return path(setting('confdir') || setting('appdir'), 'strings');
}

=head2 cache

  cache($lang, $set);

If the set is not defined, reads the set yml file into the cache.

=cut

sub cache {
    my ($lang, $set) = @_;
    return if defined $messages->{$lang}{$set};

    my $path = path(root, $lang, $set . '.yml');
    $messages->{$lang}{$set} = YAML::LoadFile($path);
}

register_plugin;

1;

=head1 AUTHOR

Erik J. Sturcke

=cut
