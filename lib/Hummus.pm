package Hummus;
use Dancer ':syntax';
layout 'main';

our $VERSION = '0.1';

get '/' => sub {
    template 'application';
};

true;
