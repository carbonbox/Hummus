package Hummus;

use Modern::Perl;
use Dancer ':syntax';
use Dancer::Plugin::i18n;
use Dancer::Plugin::Email;

use TryCatch;
use Hummus::Model::User;

our $VERSION = '0.1';

get '/login' => sub {
    template 'login', { s => strings 'login' };
};

post '/login' => sub {
    my $user   = Hummus::Model::User->new( email => params->{email} );
    my @errors = ();

    # check for login errors
    if (not $user) {
        push @errors, (strings error => 'bad_credentials');
    }
    elsif (not $user->is_password(params->{password})) {
        push @errors, (strings error => 'bad_credentials');
    }
    elsif (not $user->active) {
        push @errors, (strings error => 'not_active');
    }

    # errors mean reload this page
    return template 'login', { errors => \@errors, s => strings 'login' } if @errors;

    # otherwise we start using the app
    session user => $user->user;
    redirect '/';
};

get '/logout' => sub {
    session->destroy;
    template 'login', { messages => [ strings login => 'logout' ], s => strings 'login' };
};

get '/register' => sub {
    template 'register', { s => strings 'registration' };
};

post '/register' => sub {
    try {
        my $user = Hummus::Model::User->register(params->{email}, params->{password});
        email {
            to      => params->{email},
            subject => (message reg_email => 'subject'),
            message => (message reg_email => 'welcome') . "\n\n" .
                (message reg_email => 'body_1') . "\n\n" .
                "  http://localhost:3000/activate/" . $user->key . "\n\n".
                (message reg_email => 'signature'),
        };
        return template 'registered', { s => strings 'registration' };
    }
    catch ($e) {
        my $error;
        given ($e) {
            when (Hummus::Model::User::ALREADY_REGISTERED) { $error = strings error => 'already_registered' };
            default { die $e };
        }
        return template 'register', { errors => [ $error ], s => strings 'registration' };
    }
};

get '/activate/:key' => sub {
    my $user = Hummus::Model::User->new( key => params->{key} );
    $user->update( active => 1 ) and redirect '/login' if $user;
    template 'activate', { invalid_key => params->{key} };
};

get '/activate' => sub {
    template 'activate';
};

post '/activate' => sub {
    my $user = Hummus::Model::User->new( key => params->{key} );
    $user->update( active => 1 ) and redirect '/login' if $user;
    template 'activate', { invalid_key => params->{key} };
};

get '/' => sub {
    return redirect '/login' unless session 'user';
    template 'application';
};

true;
