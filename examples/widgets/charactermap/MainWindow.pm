package MainWindow;

use strict;
use warnings;
use blib;

use List::Util qw( max );
use Qt4;
use Qt4::isa qw( Qt4::MainWindow );
use Qt4::slots
    findStyles => ['QFont'],
    findSizes => ['QFont'],
    insertCharacter => ['QString'],
    updateClipboard => [];

use CharacterWidget;

sub characterWidget() {
    return this->{characterWidget};
}

sub clipboard() {
    return this->{clipboard};
}

sub styleCombo() {
    return this->{styleCombo};
}

sub sizeCombo() {
    return this->{sizeCombo};
}

sub fontCombo() {
    return this->{fontCombo};
}

sub lineEdit() {
    return this->{lineEdit};
}

sub scrollArea() {
    return this->{scrollArea};
}

sub fontMerging() {
    return this->{fontMerging};
}

sub setCharacterWidget {
    return this->{characterWidget} = shift;
}

sub setClipboard {
    return this->{clipboard} = shift;
}

sub setStyleCombo {
    return this->{styleCombo} = shift;
}

sub setSizeCombo {
    return this->{sizeCombo} = shift;
}

sub setFontCombo {
    return this->{fontCombo} = shift;
}

sub setLineEdit {
    return this->{lineEdit} = shift;
}

sub setScrollArea {
    return this->{scrollArea} = shift;
}

sub setFontMerging {
    return this->{fontMerging} = shift;
}

# [0]
sub NEW {
    my ( $class, $parent ) = @_;
    $class->SUPER::NEW( $parent );

    my $centralWidget = Qt4::Widget();

    my $fontLabel = Qt4::Label(this->tr('Font:'));
    this->setFontCombo( Qt4::FontComboBox() );
    my $sizeLabel = Qt4::Label(this->tr('Size:'));
    this->setSizeCombo( Qt4::ComboBox() );
    my $styleLabel = Qt4::Label(this->tr('Style:'));
    this->setStyleCombo( Qt4::ComboBox() );
    my $fontMergingLabel = Qt4::Label(this->tr('Automatic Font Merging:'));
    this->setFontMerging( Qt4::CheckBox() );
    this->fontMerging->setChecked(1);

    this->setScrollArea( Qt4::ScrollArea() );
    this->setCharacterWidget( CharacterWidget() );
    this->scrollArea->setWidget(this->characterWidget);
# [0]

# [1]
    this->findStyles(this->fontCombo->currentFont());
# [1]
    this->findSizes(this->fontCombo->currentFont());

# [2]
    this->setLineEdit( Qt4::LineEdit() );
    my $clipboardButton = Qt4::PushButton(this->tr('&To clipboard'));
# [2]

# [3]
    this->setClipboard( Qt4::Application::clipboard() );
# [3]

# [4]
    this->connect(this->fontCombo, SIGNAL 'currentFontChanged(const QFont &)',
            this, SLOT 'findStyles(const QFont &)');
    this->connect(this->fontCombo, SIGNAL 'currentFontChanged(const QFont &)',
            this, SLOT 'findSizes(const QFont &)');
    this->connect(this->fontCombo, SIGNAL 'currentFontChanged(const QFont &)',
            this->characterWidget, SLOT 'updateFont(const QFont &)');
    this->connect(this->sizeCombo, SIGNAL 'currentIndexChanged(const QString &)',
            this->characterWidget, SLOT 'updateSize(const QString &)');
    this->connect(this->styleCombo, SIGNAL 'currentIndexChanged(const QString &)',
            this->characterWidget, SLOT 'updateStyle(const QString &)');
# [4] //! [5]
    this->connect(this->characterWidget, SIGNAL 'characterSelected(const QString &)',
            this, SLOT 'insertCharacter(const QString &)');
    this->connect($clipboardButton, SIGNAL 'clicked()', this, SLOT 'updateClipboard()');
# [5]
    this->connect(this->fontMerging, SIGNAL 'toggled(bool)', this->characterWidget, SLOT 'updateFontMerging(bool)');

# [6]
    my $controlsLayout = Qt4::HBoxLayout();
    $controlsLayout->addWidget($fontLabel);
    $controlsLayout->addWidget(this->fontCombo, 1);
    $controlsLayout->addWidget($sizeLabel);
    $controlsLayout->addWidget(this->sizeCombo, 1);
    $controlsLayout->addWidget($styleLabel);
    $controlsLayout->addWidget(this->styleCombo, 1);
    $controlsLayout->addWidget($fontMergingLabel);
    $controlsLayout->addWidget(this->fontMerging, 1);
    $controlsLayout->addStretch(1);

    my $lineLayout = Qt4::HBoxLayout();
    $lineLayout->addWidget(this->lineEdit, 1);
    $lineLayout->addSpacing(12);
    $lineLayout->addWidget($clipboardButton);

    my $centralLayout = Qt4::VBoxLayout();
    $centralLayout->addLayout($controlsLayout);
    $centralLayout->addWidget(this->scrollArea, 1);
    $centralLayout->addSpacing(4);
    $centralLayout->addLayout($lineLayout);
    $centralWidget->setLayout($centralLayout);

    this->setCentralWidget($centralWidget);
    this->setWindowTitle(this->tr('Character Map'));
}
# [6]

# [7]
sub findStyles {
    my ($font) = @_;
    my $fontDatabase = Qt4::FontDatabase();
    my $currentItem = this->styleCombo->currentText();
    this->styleCombo->clear();
# [7]

# [8]
    foreach my $style ( @{$fontDatabase->styles($font->family())} ) {
        this->styleCombo->addItem($style);
    }

    my $styleIndex = this->styleCombo->findText($currentItem);

    if ($styleIndex == -1) {
        this->styleCombo->setCurrentIndex(0);
    }
    else {
        this->styleCombo->setCurrentIndex($styleIndex);
    }
}
# [8]

sub findSizes {
    my ($font) = @_;
    my $fontDatabase = Qt4::FontDatabase();
    my $currentSize = this->sizeCombo->currentText();
    this->sizeCombo->blockSignals(1);
    this->sizeCombo->clear();

    if($fontDatabase->isSmoothlyScalable($font->family(), $fontDatabase->styleString($font))) {
        foreach my $size ( @{Qt4::FontDatabase::standardSizes()} ) {
            this->sizeCombo->addItem("$size");
            this->sizeCombo->setEditable(1);
        }

    } else {
        foreach my $size ( @{$fontDatabase->smoothSizes($font->family(), $fontDatabase->styleString($font))} ) {
            this->sizeCombo->addItem("$size");
            this->sizeCombo->setEditable(0);
        }
    }

    this->sizeCombo->blockSignals(0);

    my $sizeIndex = this->sizeCombo->findText($currentSize);

    if($sizeIndex == -1) {
        this->sizeCombo->setCurrentIndex(max(0, this->sizeCombo->count() / 3));
    }
    else {
        this->sizeCombo->setCurrentIndex($sizeIndex);
    }
}

# [9]
sub insertCharacter {
    my ($character) = @_;
    this->lineEdit->insert($character);
}
# [9]

# [10]
sub updateClipboard {
# [11]
    this->clipboard->setText(this->lineEdit->text(), Qt4::Clipboard::Clipboard());
# [11]
    this->clipboard->setText(this->lineEdit->text(), Qt4::Clipboard::Selection());
}
# [10]

1;
