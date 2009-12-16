package LCDRange;

use strict;
use warnings;
use blib;

use Qt4;
use Qt4::isa qw(Qt4::Widget);
use Qt4::slots setValue => ['int'],
              setRange => ['int', 'int'];
use Qt4::signals valueChanged => ['int'];

sub NEW {
    shift->SUPER::NEW(@_);

    my $lcd = Qt4::LCDNumber(2);
    $lcd->setSegmentStyle(Qt4::LCDNumber::Filled());

    my $slider = Qt4::Slider(Qt4::Horizontal());
    $slider->setRange(0, 99);
    $slider->setValue(0);

    this->connect($slider, SIGNAL "valueChanged(int)",
                  $lcd, SLOT "display(int)");
    this->connect($slider, SIGNAL "valueChanged(int)",
                  this, SIGNAL "valueChanged(int)");

    my $layout = Qt4::VBoxLayout;
    $layout->addWidget($lcd);
    $layout->addWidget($slider);
    this->setLayout($layout);

    this->setFocusProxy($slider);

    this->{slider} = $slider;
}

sub value {
    return this->{slider}->value();
}

sub setValue {
    my ( $value ) = @_;
    this->{slider}->setValue($value);
}

sub setRange {
    my ( $minValue, $maxValue ) = @_;
    if (($minValue < 0) || ($maxValue > 99) || ($minValue > $maxValue)) {
        Qt4::qWarning("LCDRange::setRange(%d, %d)\n" .
                     "\tRange must be 0..99\n" .
                     "\tand minValue must not be greater than maxValue",
                     $minValue, $maxValue);
        return;
    }
    this->{slider}->setRange($minValue, $maxValue);
}

1;
