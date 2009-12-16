package MainWindow;

use strict;
use warnings;
use blib;

use Qt4;
use Qt4::isa qw( Qt4::MainWindow );

use StyleSheetEditor;
use Ui_MainWindow;

use Qt4::slots
    on_editStyleAction_triggered => [],
    on_aboutAction_triggered => [];

sub NEW {
    my ( $class, $parent ) = @_;
    $class->SUPER::NEW( $parent );

    my $ui = Ui_MainWindow->setupUi(this);

    $ui->nameLabel()->setProperty("class", Qt4::Variant(Qt4::String("mandatory Qt4::Label")));

    my $styleSheetEditor = StyleSheetEditor(this);
    this->{styleSheetEditor} = $styleSheetEditor;

    this->statusBar()->addWidget(Qt4::Label(this->tr("Ready")));

    this->connect($ui->exitAction(), SIGNAL 'triggered()', qApp, SLOT 'quit()');
    this->connect($ui->aboutQtAction(), SIGNAL 'triggered()', qApp, SLOT 'aboutQt()');
}

sub styleSheetEditor {
    return this->{styleSheetEditor};
}

sub on_editStyleAction_triggered {
    this->styleSheetEditor()->show();
    this->styleSheetEditor()->activateWindow();
}

sub on_aboutAction_triggered {
    Qt4::MessageBox::about(this, this->tr('About Style sheet'),
        this->tr('The <b>Style Sheet</b> example shows how widgets can be styled ' .
           'using <a href=\'http://doc.trolltech.com/4.2/stylesheet.html\'>Qt4 ' .
           'Style Sheets</a>. Click <b>File|Edit Style Sheet</b> to pop up the ' .
           'style editor, and either choose an existing style sheet or design ' .
           'your own.'));
}

1;
