package Hummus;

use Modern::Perl;
use Dancer ':syntax';

our $VERSION = '0.1';

get '' => sub {
    template 'login';
};

get '/login' => sub {

};

get '/logout' => sub {
    
    redirect '/login';
};

get '/register' => sub {
    template 'register';
};

get '/' => sub {
    return redirect '/login' unless session('user');
    template 'application';
};

true;
