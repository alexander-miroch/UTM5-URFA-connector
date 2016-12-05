package Packet;


require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(init);

my $error;
my ($code, $len, $data);
my ($version, $sock);
my @attr;

sub new {
        my $class = shift;
        my $obj = {};
        my $ref = ref($class) || $class;
	my $args = shift;

        bless ($obj, $class);
	$obj->{'version'} = $args->{'version'};
	$obj->{'sock'} = $args->{'sock'};

	$obj->flush();
        return $obj;
}

sub flush {
	my $self = shift;


	$self->{'code'} = 0;
	$self->{'len'} = 4;
	$self->{'data'} = 0;
	$#{$self->{'attr'}} = -1;
}


sub read {
	my $self = shift;
	my $buf;

	sysread $self->{'sock'}, $buf, 1;
	$self->{'code'} = ord($buf);

	sysread $self->{'sock'}, $buf, 1;
	unless (ord($buf) == $self->{'version'}) {
		print "Error ".ord($buf)."v=".$self->{'version'}."\n";
		return -1;
	};

	sysread $self->{'sock'}, $buf, 2;
	$self->{'len'} = unpack ("n",$buf);

	$self->process_packet();
}



sub process_packet {
	my $self = shift;
	my ($tlen, $slen, $rlen);
	my ($code, $buf);
	my $data;
	
	for ($tlen = 4; $tlen < $self->{'len'}; $tlen += $slen) {
		sysread $self->{'sock'}, $buf, 2;
		$code = unpack("s",$buf);
	
		sysread $self->{'sock'}, $buf, 2;
		$slen = unpack("n",$buf);

		last if ($slen == 4);

		sysread $self->{'sock'}, $buf, $slen - 4;

		$self->{'attr'}[$code]{'data'} = $buf;
		$self->{'attr'}[$code]{'len'} = $slen;
	}
}



sub setString {
	my $self = shift;
	my ($str, $code) = @_;

	$self->{'attr'}[$code]{'data'} = $str;
	$self->{'attr'}[$code]{'len'} = length($str) + 4;
	$self->{'len'} += $self->{'attr'}[$code]{'len'};
}


sub setInt {
	my $self = shift;
	my ($str, $code) = @_;

	$self->{'attr'}[$code]{'data'} = pack("N",$str);
	$self->{'attr'}[$code]{'len'} = 8;
	$self->{'len'} += 8;
}

sub getInt {
	my $self = shift;
	my $code = shift;
	
	return unpack("N", $self->{'attr'}[$code]{'data'});
}

sub write {
	my $self = shift;
	my $code = -1;

	syswrite $self->{'sock'}, chr($self->{'code'}), 1 or die "xxx $!\n";
	syswrite $self->{'sock'}, chr($self->{'version'}), 1 or die "ERRR $!\n";

	syswrite $self->{'sock'}, pack("n",$self->{'len'}), 2;
	
	foreach my $i (@{$self->{'attr'}}) {
		$code++;
		next if (!defined %$i);

		syswrite $self->{'sock'}, pack("s",$code), 2 or die "ERR $!\n";
		syswrite $self->{'sock'}, pack("n",$$i{'len'}), 2 or die "ERR $!\n";
		syswrite $self->{'sock'}, $$i{'data'}, $$i{'len'} or die "ERR $!\n";

	}
}


1;


package Packet::Stream;

require Exporter;
@ISA = qw(Exporter Packet);
@EXPORT = qw(init);


my $iter;
my @data;

sub setInt {
	my $self = shift;
	my $raw = shift;
	my $int;
	

	$idx = $#{$self->{'data'}};

	$int = pack("N",$raw);
	push @{$self->{'data'}}, $int;
	$self->{'len'} += 8;
}

sub setStr {
	my $self = shift;
	my $raw = shift;

	push @{$self->{'data'}}, $raw;
	$self->{'len'} += length($raw) + 4;
}


sub flush {
	my $self = shift;

	$self->SUPER::flush();
	$#{$self->{'data'}} = -1; 
	$self->{'iter'} = 0;
}
sub getAttrInt {
	my $self = shift;
	my $rv = shift;

	return $self->SUPER::getInt($rv);
}

sub getInt {
	my $self = shift;

	return unpack("N",${$self->{'data'}}[$self->{'iter'}++]);
}



sub getStr {
	my $self = shift;

	return ${$self->{'data'}}[$self->{'iter'}++];
}

sub getDbl {
	my $self = shift;
	my $val = ${$self->{'data'}}[$self->{'iter'}];

	$val = reverse $val;

	$self->{'iter'}++;
	return unpack("d",$val);
}

sub setDbl {
	my $self = shift;
	my $raw = shift;
	my $val;

	$val = reverse pack("d",$raw);
	
	push @{$self->{'data'}}, $val;
	$self->{'len'} += 12;	
}

sub write {
	my $self = shift;
	my $len;

	$self->{'code'} = 200;

	$|=1;
	syswrite $self->{'sock'}, chr($self->{'code'}), 1 or die "xxx $!\n";
	syswrite $self->{'sock'}, chr($self->{'version'}), 1 or die "ERRR $!\n";
	syswrite $self->{'sock'}, pack("n",$self->{'len'}), 2 or die "EEEEEEERR $!\n";

	foreach my $i (@{$self->{'data'}}) {	
		$len = length($i) + 4;
		next if ($len == 4);

		syswrite $self->{'sock'}, pack("s",5), 2 or die "ERRR $!\n";
		syswrite $self->{'sock'}, pack("n",$len), 2 or die "ERR ->$!\n";
		syswrite $self->{'sock'}, $i, $len or die "ERR $i,$len->$!\n";
	}
}

#sub read {
#	my $self = shift;
#
#	$self->SUPER::read();
#		
#}

sub process_packet {
	my $self = shift;
	my ($tlen, $slen, $rlen);
	my ($code, $buf);
	my $data;
	
	for ($tlen = 4; $tlen < $self->{'len'}; $tlen += $slen) {
		sysread $self->{'sock'}, $buf, 2;
		$code = unpack("s",$buf);
	
		sysread $self->{'sock'}, $buf, 2;
		$slen = unpack("n",$buf);

		next if ($slen == 4);

		sysread $self->{'sock'}, $buf, $slen - 4;

		if ($code == 5) {
			push @{$self->{'data'}} ,$buf;
		} else {
			$self->{'attr'}[$code]{'data'} = $buf;
			$self->{'attr'}[$code]{'len'} = $slen;
		}
	}
}

use Socket;
sub getIP {
	my $self = shift;
	my $binip;

	$binip =  unpack("N",${$self->{'data'}}[$self->{'iter'}++]);
	return inet_ntoa(pack("N*", $binip));
}

1;












