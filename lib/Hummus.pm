package Hummus;

use Modern::Perl;
use Dancer ':syntax';
use Dancer::Plugin::Email;

use TryCatch;
use Hummus::Model::User;

our $VERSION = '0.1';

get '/login' => sub {
    template 'login';
};

post '/login' => sub {
    my $user = Hummus::Model::User->new( email => params->{email} );
    return template 'login', { bad_credentials => 1 } unless $user && $user->is_password(params->{password});
    return template 'login', { not_active      => 1 } unless $user->active;
    session user => $user->user;
    redirect '/';
};

get '/logout' => sub {
    session->destroy;
    redirect '/login';
};

get '/register' => sub {
    template 'register';
};

post '/register' => sub {
    try {
        my $user = Hummus::Model::User->register(params->{email}, params->{password});
        email {
            to => params->{email},
            subject => "Hummus account activiation",
            message => "Welcome!\n\n" .
                "Thanks for registering for Hummus. The next step is to activate your account. " .
                "To do so, please click on the link below:\n\n" .
                "  http://localhost:3000/activate/" . $user->key . "\n\n".
                "Hummus Team",
        };
        return template 'registered';
    }
    catch ($e) {
        return template 'register', { error => $e };
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
