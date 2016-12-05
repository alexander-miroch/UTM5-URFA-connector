package URFA;

use IO::Socket::SSL;
use Digest::MD5 qw(md5);
use Packet;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(belive_me);

my $sock;
my $inited = 0;
my $error;
my ($uname,$upass);

sub new {
	my $class = shift;
	my $obj = {};
	my $ref = ref($class) || $class;
	
	bless ($obj, $class);
	return $obj;
}


sub belive_me {
	my $self = shift;
	my %params = @_;
	my $ssl;
	my $packet;

	unless (%params) {
		$self->{error} = "no params given";
		return -1;
	}

	print "Initializing urfa\n";

#	$self->{sock} = IO::Socket::SSL->new(
	$self->{sock} = IO::Socket::INET->new(
			PeerAddr => $params{'host'}, 
			PeerPort => $params{'port'},
#			SSL_version => 'sslv2',
#			SSL_cipher_list => "RC4-MD5",
		);
	if (!defined($self->{sock})) {
		#$self->{error} = IO::Socket::SSL::errstr();
		$self->{error} = IO::Socket::INET::errstr();
		return -1;
	}
	
	$self->{'uname'} = $params{'login'};
	$self->{'upass'} = $params{'password'};
		
	return -1 if ($self->login() < 0);	
	$self->{inited} = 1;


}




sub login {
	my $self = shift;
	my $sock = $self->{sock};
	my ($digest, $hash);
	my $md5;
	my $packet;	
	my $res = 0;

	$packet = new Packet({ sock => $self->{sock},
				version => 35 });

	if ($packet->read() == -1) {
		$self->{'error'} = "Packet read error";
		return -1;
	}

	if ($packet->{'code'} != 192) {
		$self->{'error'} = "Currently only one auth protocol supported, sorry";
		return -1;
	}
	
	$digest =  $packet->{'attr'}[6]{'data'};

	$md5 = Digest::MD5->new();
	$md5->add($digest,$self->{'upass'});
	$hash = $md5->digest();

	$packet->flush();
	$packet->{'code'} = 193;

	$packet->setString($self->{'uname'},2);
	$packet->setString($digest,8);
	$packet->setString($hash,9);
	
	# SSL isn't supported yet
	$packet->setInt(0,10);

	# WTF?
	$packet->setInt(2,1);
	$packet->write();
	
	$packet->flush();
	$packet->read();

	if ($packet->{'code'} != 195 &&
		$packet->{'code'} != 194) {
		$self->{'error'} = "Strange auth result";
		return -1;
	}

	if ($packet->{'code'} == 195) {
		$res = $packet->getInt(4);
		$self->{'error'} = "Access rejected, code $res";
		return -1;
	} elsif ($packet->{'code'} == 194) {
		print "Access granted\n";
	} else {
		$self->{'error'} = "Strange auth code " . $packet->{'code'};
		return -1;
	}

	0;
}


sub rpc_call {
	my $self = shift;
	my $code = shift;
	my $packet;
	my $retcode;
	
	$packet = new Packet({ sock => $self->{sock},
				version => 35 });

	$packet->{'code'} = 201;
	$packet->setInt($code,3);
	$packet->write();

	$packet->flush();
	$packet->read();

	if ($packet->{'code'} != 200) {
		$self->{'error'} = "RPC call failed with " . $packet->{'code'};
		return -1;
	}

	$retcode = $packet->getInt(3);

	if ($retcode != $code) {
		$self->{'error'} = "Corrupted answer with " . $retcode;
		return -1;
	}

	
	0;
}


sub get_stream_data {
	my ($self,$packet) = @_;

	$packet->flush();
	while(1) {
		$packet->read();

		if ($packet->{'code'} != 200) {
			$self->{'error'} = "Stream read failed with " . $packet->{'code'};
			return -1;
		}

		$res = $packet->getAttrInt(4);
		if ($res) {
			return 0;
		}
	}

	0;
}



1;
