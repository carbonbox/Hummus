package Hummus;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'application';
};

true;
