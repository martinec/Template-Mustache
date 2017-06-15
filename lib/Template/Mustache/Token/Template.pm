package Template::Mustache::Token::Template;

use Moo;

use MooseX::MungeHas { has_ro => [ 'is_ro' ] };

has_ro 'items';

sub flatten {
    return map { ref $_ eq 'ARRAY' ? flatten(@$_) : $_ } grep { ref } @_;
}

sub render {
    my( $self, $context, $partials, $indent ) = @_;

    my @nodes = grep { ref $_ ne 'Template::Mustache::Token::Verbatim' or
        length $_->content } flatten( @{ $self->items } );

    if( @nodes and ref $nodes[-1] eq 'Template::Mustache::Token::Verbatim' ) {
        $nodes[-1]->last(1);
    }

    return join '', map { $_->render($context, $partials, $indent ) } @nodes;
}

1;
