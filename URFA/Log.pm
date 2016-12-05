package URFA::Log;

use POSIX qw/strftime/;


require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(belive_me);


sub new {
        my $class = shift;
        my $obj = {};
        my $ref = ref($class) || $class;
	my $file = shift;

	print "file=$file\n";
	$obj->{'logfile'} = $file;
        bless ($obj, $class);

	return $obj->init();
}

sub init {
	my $self = shift;
	my $rv;

	$rv = open FD , ">>" . $self->{'logfile'} ;

	if (!$rv) {
		print "Failed to open".$self->{'logfile'}." $!\n";
		return -1;
	}
	select FD;
	$self->log("Log started");

	return $self;
}

sub log {
	my $self = shift;
	my ($str,$val) = @_;
	my $time;

	$time = strftime( "%d.%m.%y %H:%M:%S", localtime(time()) );

	$val = "" unless (defined($val));
	print "[" . $time . "] " . $val . " " . $str . "\n";

}

sub error {
	my $self = shift;

	$self->log(shift,"ERROR");
}

sub debug {
	my $self = shift;

	$self->log(shift,"DEBUG");
}
