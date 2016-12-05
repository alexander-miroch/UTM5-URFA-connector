
package URFA::Client;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw();

use constant VERSION => 35;

sub size {
        my $self = shift;
        my @args = @_;
        my ($arg,$cnt);
        my $obj;
        my $total = $#args + 1;

        $obj = $self->{'obj'};
        for (my $i = 0; $i < $total; $i++) {
                $arg = $args[$i];
                $cnt = $self->process($obj,$arg);
        }
	return 0 if ($cnt == -1);
	return $cnt;
}

sub get_var {
	my $self = shift;
	my $var = shift;
	my $obj;
	my $rv;

	$obj = $self->{'obj'};
	$rv = $self->process($obj,$var,1);
	if ($rv == -1) {
		$obj = $self->{'rv'};
		$rv = $self->process($rv,$var,1);
	}

	return $rv;

}

sub process {
        my $self = shift;
        my ($entry,$tok, $var) = @_;
        my $rv;
        our $saved_array;

        foreach my $h (keys %$entry) {
                if ($tok eq $h) {
                        #return (defined($var)) ? $$entry{$h} : $#{$saved_array} + 1;
                        return (defined($var)) ? \@{$saved_array} : $#{$saved_array} + 1;
                }
                if (ref($$entry{$h}) eq ARRAY) {
                        $saved_array = $$entry{$h};
                        $rv = $self->do_array($$entry{$h},$tok,$var);
                        next if ($rv == -1);
                        return $rv;
                } elsif (ref($$entry{$h}) eq HASH) {
                        $rv = $self->process($$entry{$h},$tok,$var);
                        next if ($rv == -1);

                        return $rv;
                }
        }
        return -1;
}

sub do_array {
        my $self = shift;
        my ($entry,$tok, $var) = @_;
        my $rv;
        our $saved_array;

        foreach (@$entry) {
                if (ref($_) eq HASH) {
                        $rv = $self->process($_,$tok,$var);
                        next if ($rv == -1);
                        return $rv;
                } elsif (ref($_) eq ARRAY) {
                        $saved_array = $_;
                        $rv = $self->do_array($_,$tok,$var);
                        next if ($rv == -1);
                        return $rv;
                }
        }
	return -1;
}


sub new {
	my $class = shift;
        my $obj = {};
        my $ref = ref($class) || $class;
	my $urfa = shift;

	$obj->{'urfa'} = $urfa;

        bless ($obj, $class);
        return $obj;
}


# 0x0040
sub rpcf_liburfa_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0040) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_liburfa_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'module'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'version'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'path'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x0041
sub rpcf_liburfa_load {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0041) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_liburfa_load failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'data'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x0042
sub rpcf_liburfa_unload {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0042) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_liburfa_unload failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'data'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'error'}  = $spacket->getStr();
			

	return $rv;
}

# 0x0043
sub rpcf_liburfa_reload {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0043) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_liburfa_reload failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'data'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x0044
sub rpcf_liburfa_symtab {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0044) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_liburfa_symtab failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'module'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x0045
sub rpcf_core_version {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0045) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_core_version failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'core_version'}  = $spacket->getStr();
			

	return $rv;
}

# 0x0046
sub rpcf_core_build {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0046) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_core_build failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'build'}  = $spacket->getStr();
			

	return $rv;
}

# 0x0047
sub rpcf_get_stats {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0047) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_stats failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'type'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'status'}  = $spacket->getInt();
		
	$rv->{'uptime'}  = $spacket->getInt();
		
	$rv->{'uptime_last'}  = $spacket->getInt();
		
	$rv->{'events'}  = $spacket->getInt();
		
	$rv->{'events_last'}  = $spacket->getInt();
		
	$rv->{'errors'}  = $spacket->getInt();
		
	$rv->{'errors_last'}  = $spacket->getInt();
		

	return $rv;
}

# 0x0051
sub rpcf_license_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0051) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_license_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'module'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'version'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'data'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'hash'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x0053
sub rpcf_license_import {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0053) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_license_import failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'module'});
	$spacket->setStr($href->{'version'});
	$spacket->setStr($href->{'data'});
	$spacket->setStr($href->{'hash'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x0060
sub rpcf_get_new_secret {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x0060) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_new_secret failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'secret_size'} = "8" unless exists $href->{'secret_size'};
	$spacket->setInt($href->{'secret_size'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'error'}  = $spacket->getStr();
			
	$rv->{'secret'}  = $spacket->getStr();
			

	return $rv;
}

# 0x0101
sub rpcf_get_system_currency {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x0101) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_system_currency failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'currency_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x1060
sub rpcf_get_ippool {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1060) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ippool failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		
	$rv->{'name'}  = $spacket->getStr();
			
	$rv->{'address'}  = $spacket->getInt();
		
	$rv->{'mask'}  = $spacket->getInt();
		

	return $rv;
}

# 0x1061
sub rpcf_get_ippools_list {
	my $spacket;
	my $self = shift; 
        
	if ($self->{'urfa'}->rpc_call(0x1061) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ippools_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
        
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'address'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x1062
sub rpcf_add_ippool {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1062) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_ippool failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'address'});
		
	$spacket->setInt($href->{'mask'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x1063
sub rpcf_edit_ippool {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1063) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_ippool failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'address'});
		
	$spacket->setInt($href->{'mask'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x1064
sub rpcf_del_ippool {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1064) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_ippool failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'address'});
		
	$spacket->setInt($href->{'mask'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x1200
sub rpcf_search_users {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1200) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_search_users failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'poles_count'});
		
	if ($href->{'discount_period_id'} eq "1") {
		$href->{'pole_code'} = "4" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'create_date'} eq "1") {
		$href->{'pole_code'} = "6" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'last_change'} eq "1") {
		$href->{'pole_code'} = "7" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'who_create'} eq "1") {
		$href->{'pole_code'} = "8" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'who_change'} eq "1") {
		$href->{'pole_code'} = "9" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'is_juridical'} eq "1") {
		$href->{'pole_code'} = "10" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'juridical_address'} eq "1") {
		$href->{'pole_code'} = "11" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'actual_address'} eq "1") {
		$href->{'pole_code'} = "12" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'work_telephone'} eq "1") {
		$href->{'pole_code'} = "13" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'home_telephone'} eq "1") {
		$href->{'pole_code'} = "14" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'mobile_telephone'} eq "1") {
		$href->{'pole_code'} = "15" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'web_page'} eq "1") {
		$href->{'pole_code'} = "16" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'icq_number'} eq "1") {
		$href->{'pole_code'} = "17" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'tax_number'} eq "1") {
		$href->{'pole_code'} = "18" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'kpp_number'} eq "1") {
		$href->{'pole_code'} = "19" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'house_id'} eq "1") {
		$href->{'pole_code'} = "21" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'flat_number'} eq "1") {
		$href->{'pole_code'} = "22" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'entrance'} eq "1") {
		$href->{'pole_code'} = "23" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'floor'} eq "1") {
		$href->{'pole_code'} = "24" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'email'} eq "1") {
		$href->{'pole_code'} = "25" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'passport'} eq "1") {
		$href->{'pole_code'} = "26" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'district'} eq "1") {
		$href->{'pole_code'} = "40" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	if ($href->{'building'} eq "1") {
		$href->{'pole_code'} = "41" unless exists $href->{'pole_code'};
	$spacket->setInt($href->{'pole_code'});
		
	}
							
	$spacket->setInt($href->{'select_type'});
		
	$spacket->setInt($href->{'patterns_count'});
		
	for (my $i = 0; $i < $href->{'patterns_count'}; $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'what_id'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'criteria_id'});
		
	if ($href->{'arr_0'}[$i]->{'what_id'} eq "33") {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'date_pattern'});
		
	}
							
	if ($href->{'arr_0'}[$i]->{'what_id'} ne "33") {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'pattern'});
	}
							
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_data_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'user_data_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'basic_account'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'full_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'is_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'ip_address_size'} = $spacket->getInt();
		
			
	for (my $j = 0; $j < $rv->{'ip_address_size'}; $j++) {
		
	$rv->{'arr'}[$j]->{'ip_group_size'} = $spacket->getInt();
		
			
	for (my $x = 0; $x < $rv->{'ip_group_size'}; $x++) {
		
	$rv->{'arr'}[$x]->{'type'} = $spacket->getInt();
		
	$rv->{'arr'}[$x]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$x]->{'mask'} = $spacket->getIP();
					
	} 
						
	if ($rv->{'discount_period_id'} eq "1") {
		
	$rv->{'arr'}[$j]->{'discount_period_id'} = $spacket->getInt();
		
	}
							
	if ($rv->{'create_date'} eq "1") {
		
	$rv->{'arr'}[$j]->{'create_date'} = $spacket->getInt();
		
	}
							
	if ($rv->{'last_change'} eq "1") {
		
	$rv->{'arr'}[$j]->{'last_change_date'} = $spacket->getInt();
		
	}
							
	if ($rv->{'who_create'} eq "1") {
		
	$rv->{'arr'}[$j]->{'who_create'} = $spacket->getInt();
		
	}
							
	if ($rv->{'who_change'} eq "1") {
		
	$rv->{'arr'}[$j]->{'who_change'} = $spacket->getInt();
		
	}
							
	if ($rv->{'is_juridical'} eq "1") {
		
	$rv->{'arr'}[$j]->{'is_juridical'} = $spacket->getInt();
		
	}
							
	if ($rv->{'juridical_address'} eq "1") {
		
	$rv->{'arr'}[$j]->{'juridical_address'} = $spacket->getStr();
			
	}
							
	if ($rv->{'actual_address'} eq "1") {
		
	$rv->{'arr'}[$j]->{'actual_address'} = $spacket->getStr();
			
	}
							
	if ($rv->{'work_telephone'} eq "1") {
		
	$rv->{'arr'}[$j]->{'work_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'home_telephone'} eq "1") {
		
	$rv->{'arr'}[$j]->{'home_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'mobile_telephone'} eq "1") {
		
	$rv->{'arr'}[$j]->{'mobile_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'web_page'} eq "1") {
		
	$rv->{'arr'}[$j]->{'web_page'} = $spacket->getStr();
			
	}
							
	if ($rv->{'icq_number'} eq "1") {
		
	$rv->{'arr'}[$j]->{'icq_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'tax_number'} eq "1") {
		
	$rv->{'arr'}[$j]->{'tax_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'kpp_number'} eq "1") {
		
	$rv->{'arr'}[$j]->{'kpp_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'house_id'} eq "1") {
		
	$rv->{'arr'}[$j]->{'house_id'} = $spacket->getInt();
		
	}
							
	if ($rv->{'flat_number'} eq "1") {
		
	$rv->{'arr'}[$j]->{'flat_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'entrance'} eq "1") {
		
	$rv->{'arr'}[$j]->{'entrance'} = $spacket->getStr();
			
	}
							
	if ($rv->{'floor'} eq "1") {
		
	$rv->{'arr'}[$j]->{'floor'} = $spacket->getStr();
			
	}
							
	if ($rv->{'email'} eq "1") {
		
	$rv->{'arr'}[$j]->{'email'} = $spacket->getStr();
			
	}
							
	if ($rv->{'passport'} eq "1") {
		
	$rv->{'arr'}[$j]->{'passport'} = $spacket->getStr();
			
	}
							
	if ($rv->{'district'} eq "1") {
		
	$rv->{'arr'}[$j]->{'district'} = $spacket->getStr();
			
	}
							
	if ($rv->{'building'} eq "1") {
		
	$rv->{'arr'}[$j]->{'building'} = $spacket->getStr();
			
	}
							
	} 
						
	} 
						

	return $rv;
}

# 0x1201
sub rpcf_search_cards {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1201) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_search_cards failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'select_type'});
		$href->{'patterns_count'} = $self->size(what_id) unless exists $href->{'patterns_count'};
	$spacket->setInt($href->{'patterns_count'});
		
	for (my $i = 0; $i < $self->size(what_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'what_id'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'criteria_id'});
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'pattern'});
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'cards_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cards_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'card_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'pool_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'secret'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'currency'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'expire'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'days'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_used'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tp_id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x1202
sub rpcf_search_users_ligth {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1202) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_search_users_ligth failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'email'});
	$spacket->setStr($href->{'fname'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'success'}  = $spacket->getInt();
		
	$rv->{'total'}  = $spacket->getInt();
		
	$rv->{'show_count'}  = $spacket->getInt();
		
	if ($rv->{'show_count'} ne "0") {
		
			
	for (my $i = 0; $i < $rv->{'show_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'email'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	} 
						
	}
							

	return $rv;
}

# 0x1205
sub rpcf_search_users_new {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x1205) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_search_users_new failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'poles_count'} = $self->size(pole_code_array) unless exists $href->{'poles_count'};
	$spacket->setInt($href->{'poles_count'});
		
	for (my $i = 0; $i < $self->size(pole_code_array); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'pole_code_array'});
		
	} 
						
	$spacket->setInt($href->{'select_type'});
		$href->{'patterns_count'} = $self->size(what_id) unless exists $href->{'patterns_count'};
	$spacket->setInt($href->{'patterns_count'});
		
	for (my $i = 0; $i < $self->size(what_id); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'what_id'});
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'criteria_id'});
		
	if ($href->{'arr_1'}[$i]->{'what_id'} eq "33") {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'data_pattern'});
		
	}
							
	if ($href->{'arr_1'}[$i]->{'what_id'} ne "33") {
		
	$spacket->setStr($href->{'arr_1'}[$i]->{'pattern'});
	}
							
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_data_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'user_data_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'basic_account'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'full_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'is_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'ip_address_size'}  = $spacket->getInt();
		
		$rv->{'ip_address_size_array'} = $self->get_var("ip_address_size");
									
			
	for (my $j = 0; $j < $rv->{'ip_address_size'}; $j++) {
		
	$rv->{'ip_group_size'}  = $spacket->getInt();
		
		$rv->{'ip_group_size_array'} = $self->get_var("ip_group_size");
									
			
	for (my $x = 0; $x < $rv->{'ip_group_size'}; $x++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'mask'} = $spacket->getIP();
					
	} 
						
	} 
						
			
	for (my $z = 0; $z < $self->size(pole_code_array); $z++) {
		
		$rv->{'pole_code'} = ${$self->get_var("pole_code_array")}[$z]->{'pole_code_array'};
									
	if ($rv->{'pole_code'} eq "4") {
		
	$rv->{'arr'}[$i]->{'discount_period_id'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "6") {
		
	$rv->{'arr'}[$i]->{'create_date'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "7") {
		
	$rv->{'arr'}[$i]->{'last_change_date'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "8") {
		
	$rv->{'arr'}[$i]->{'who_create'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "9") {
		
	$rv->{'arr'}[$i]->{'who_change'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "10") {
		
	$rv->{'arr'}[$i]->{'is_juridical'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "11") {
		
	$rv->{'arr'}[$i]->{'juridical_address'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "12") {
		
	$rv->{'arr'}[$i]->{'actual_address'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "13") {
		
	$rv->{'arr'}[$i]->{'work_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "14") {
		
	$rv->{'arr'}[$i]->{'home_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "15") {
		
	$rv->{'arr'}[$i]->{'mobile_telephone'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "16") {
		
	$rv->{'arr'}[$i]->{'web_page'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "17") {
		
	$rv->{'arr'}[$i]->{'icq_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "18") {
		
	$rv->{'arr'}[$i]->{'tax_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "19") {
		
	$rv->{'arr'}[$i]->{'kpp_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "21") {
		
	$rv->{'arr'}[$i]->{'house_id'} = $spacket->getInt();
		
	}
							
	if ($rv->{'pole_code'} eq "22") {
		
	$rv->{'arr'}[$i]->{'flat_number'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "23") {
		
	$rv->{'arr'}[$i]->{'entrance'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "24") {
		
	$rv->{'arr'}[$i]->{'floor'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "25") {
		
	$rv->{'arr'}[$i]->{'email'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "26") {
		
	$rv->{'arr'}[$i]->{'passport'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "40") {
		
	$rv->{'arr'}[$i]->{'district'} = $spacket->getStr();
			
	}
							
	if ($rv->{'pole_code'} eq "41") {
		
	$rv->{'arr'}[$i]->{'building'} = $spacket->getStr();
			
	}
							
	} 
						
	} 
						

	return $rv;
}

# 0x2001
sub rpcf_get_users_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_users_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'from'});
		
	$spacket->setInt($href->{'to'});
		$href->{'card_user'} = "0" unless exists $href->{'card_user'};
	$spacket->setInt($href->{'card_user'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'cnt'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cnt'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'basic_account'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'full_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'is_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'ip_adr_size'}  = $spacket->getInt();
		
		$rv->{'ip_adr_size_array'} = $self->get_var("ip_adr_size");
									
			
	for (my $j = 0; $j < $rv->{'ip_adr_size'}; $j++) {
		
	$rv->{'group_size'}  = $spacket->getInt();
		
		$rv->{'group_size_array'} = $self->get_var("group_size");
									
			
	for (my $x = 0; $x < $rv->{'group_size'}; $x++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'ip_address'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'group_type'} = $spacket->getInt();
		
	} 
						
	} 
						
	$rv->{'arr'}[$i]->{'user_int_status'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2003
sub rpcf_change_intstat_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_change_intstat_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'need_block'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2005
sub rpcf_add_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2005) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'password'});$href->{'full_name'} = "dummy" unless exists $href->{'full_name'};
	$spacket->setStr($href->{'full_name'});
	if ($href->{'user_id'} eq "0") {
		$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		
	}
							$href->{'is_juridical'} = "0" unless exists $href->{'is_juridical'};
	$spacket->setInt($href->{'is_juridical'});
		$href->{'jur_address'} = "dummy" unless exists $href->{'jur_address'};
	$spacket->setStr($href->{'jur_address'});$href->{'act_address'} = "dummy" unless exists $href->{'act_address'};
	$spacket->setStr($href->{'act_address'});$href->{'flat_number'} = "dummy" unless exists $href->{'flat_number'};
	$spacket->setStr($href->{'flat_number'});$href->{'entrance'} = "dummy" unless exists $href->{'entrance'};
	$spacket->setStr($href->{'entrance'});$href->{'floor'} = "dummy" unless exists $href->{'floor'};
	$spacket->setStr($href->{'floor'});$href->{'district'} = "dummy" unless exists $href->{'district'};
	$spacket->setStr($href->{'district'});$href->{'building'} = "dummy" unless exists $href->{'building'};
	$spacket->setStr($href->{'building'});$href->{'passport'} = "dummy" unless exists $href->{'passport'};
	$spacket->setStr($href->{'passport'});$href->{'house_id'} = "0" unless exists $href->{'house_id'};
	$spacket->setInt($href->{'house_id'});
		$href->{'work_tel'} = "dummy" unless exists $href->{'work_tel'};
	$spacket->setStr($href->{'work_tel'});$href->{'home_tel'} = "dummy" unless exists $href->{'home_tel'};
	$spacket->setStr($href->{'home_tel'});$href->{'mob_tel'} = "dummy" unless exists $href->{'mob_tel'};
	$spacket->setStr($href->{'mob_tel'});$href->{'web_page'} = "dummy" unless exists $href->{'web_page'};
	$spacket->setStr($href->{'web_page'});$href->{'icq_number'} = "dummy" unless exists $href->{'icq_number'};
	$spacket->setStr($href->{'icq_number'});$href->{'tax_number'} = "dummy" unless exists $href->{'tax_number'};
	$spacket->setStr($href->{'tax_number'});$href->{'kpp_number'} = "dummy" unless exists $href->{'kpp_number'};
	$spacket->setStr($href->{'kpp_number'});$href->{'email'} = "dummy" unless exists $href->{'email'};
	$spacket->setStr($href->{'email'});$href->{'bank_id'} = "0" unless exists $href->{'bank_id'};
	$spacket->setInt($href->{'bank_id'});
		$href->{'bank_account'} = "dummy" unless exists $href->{'bank_account'};
	$spacket->setStr($href->{'bank_account'});$href->{'comments'} = "dummy" unless exists $href->{'comments'};
	$spacket->setStr($href->{'comments'});$href->{'personal_manager'} = "dummy" unless exists $href->{'personal_manager'};
	$spacket->setStr($href->{'personal_manager'});$href->{'connect_date'} = "0" unless exists $href->{'connect_date'};
	$spacket->setInt($href->{'connect_date'});
		$href->{'is_send_invoice'} = "0" unless exists $href->{'is_send_invoice'};
	$spacket->setInt($href->{'is_send_invoice'});
		$href->{'advance_payment'} = "0" unless exists $href->{'advance_payment'};
	$spacket->setInt($href->{'advance_payment'});
		$href->{'parameters_count'} = $self->size(parameter_value) unless exists $href->{'parameters_count'};
	$spacket->setInt($href->{'parameters_count'});
		
	for (my $i = 0; $i < $self->size(parameter_value); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'parameter_id'});
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'parameter_value'});
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_id'}  = $spacket->getInt();
		
	$rv->{'error_msg'}  = $spacket->getStr();
			
	if ($rv->{'user_id'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to add or edit user";
		return -1;				
								
	}
							
	if ($rv->{'user_id'} eq "4294967295") {
		
		$self->{'obj'}->{'error'} = "unable to add user, probably login exists";
		return -1;				
								
	}
							

	return $rv;
}

# 0x2006
sub rpcf_get_userinfo {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2006) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_userinfo failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_id'}  = $spacket->getInt();
		
	if ($rv->{'user_id'} eq "0") {
		
		$self->{'obj'}->{'error'} = "user not found";
		return -1;				
								
	}
							
	$rv->{'accounts_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'account_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_name_array'} = $spacket->getStr();
			
	} 
						
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'password'}  = $spacket->getStr();
			
	$rv->{'basic_account'}  = $spacket->getInt();
		
	$rv->{'full_name'}  = $spacket->getStr();
			
	$rv->{'create_date'}  = $spacket->getInt();
		
	$rv->{'last_change_date'}  = $spacket->getInt();
		
	$rv->{'who_create'}  = $spacket->getInt();
		
	$rv->{'who_change'}  = $spacket->getInt();
		
	$rv->{'is_juridical'}  = $spacket->getInt();
		
	$rv->{'jur_address'}  = $spacket->getStr();
			
	$rv->{'act_address'}  = $spacket->getStr();
			
	$rv->{'work_tel'}  = $spacket->getStr();
			
	$rv->{'home_tel'}  = $spacket->getStr();
			
	$rv->{'mob_tel'}  = $spacket->getStr();
			
	$rv->{'web_page'}  = $spacket->getStr();
			
	$rv->{'icq_number'}  = $spacket->getStr();
			
	$rv->{'tax_number'}  = $spacket->getStr();
			
	$rv->{'kpp_number'}  = $spacket->getStr();
			
	$rv->{'bank_id'}  = $spacket->getInt();
		
	$rv->{'bank_account'}  = $spacket->getStr();
			
	$rv->{'comments'}  = $spacket->getStr();
			
	$rv->{'personal_manager'}  = $spacket->getStr();
			
	$rv->{'connect_date'}  = $spacket->getInt();
		
	$rv->{'email'}  = $spacket->getStr();
			
	$rv->{'is_send_invoice'}  = $spacket->getInt();
		
	$rv->{'advance_payment'}  = $spacket->getInt();
		
	$rv->{'house_id'}  = $spacket->getInt();
		
	$rv->{'flat_number'}  = $spacket->getStr();
			
	$rv->{'entrance'}  = $spacket->getStr();
			
	$rv->{'floor'}  = $spacket->getStr();
			
	$rv->{'district'}  = $spacket->getStr();
			
	$rv->{'building'}  = $spacket->getStr();
			
	$rv->{'passport'}  = $spacket->getStr();
			
	$rv->{'parameters_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'parameters_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'parameter_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'parameter_value'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x200d
sub rpcf_get_login_for_slink {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x200d) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_login_for_slink failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_data_full_login'}  = $spacket->getInt();
		

	return $rv;
}

# 0x200e
sub rpcf_remove_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x200e) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2011
sub rpcf_get_users_count {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2011) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_users_count failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'card_user'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2021
sub rpcf_get_user_contacts {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2021) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_contacts failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'person'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'descr'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'contact'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'email'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'email_notify'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'short_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'birthday'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'id_exec_man'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2022
sub rpcf_put_user_contact {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2022) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_user_contact failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setStr($href->{'person'});
	$spacket->setStr($href->{'descr'});
	$spacket->setStr($href->{'contact'});
	$spacket->setStr($href->{'email'});
	$spacket->setInt($href->{'email_notify'});
		
	$spacket->setStr($href->{'short_name'});
	$spacket->setStr($href->{'birthday'});
	$spacket->setStr($href->{'id_exec_man'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2023
sub rpcf_del_user_contact {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2023) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_user_contact failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2024
sub rpcf_user_contact_get_em {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2024) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user_contact_get_em failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name_position'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2025
sub rpcf_get_user_log {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2025) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_log failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'tstart'});
		
	$spacket->setInt($href->{'tstop'});
		
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setStr($href->{'act'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'ud_login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'who'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'usd_login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'want'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'comment'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2026
sub rpcf_get_user_by_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2026) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_by_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_id'}  = $spacket->getInt();
		
	if ($rv->{'user_id'} eq "0") {
		
		$self->{'obj'}->{'error'} = "No such account linked with user";
		return -1;				
								
	}
							

	return $rv;
}

# 0x2028
sub rpcf_rpost_start_working {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2028) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_rpost_start_working failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'tafrif'});
		
	$spacket->setDbl($href->{'amount_traffic'});
	$spacket->setDbl($href->{'amount_periodic'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getStr();
			

	return $rv;
}

# 0x2029
sub rpcf_rpost_stop_working {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2029) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_rpost_stop_working failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getStr();
			

	return $rv;
}

# 0x202b
sub rpcf_rpost_report_get {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x202b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_rpost_report_get failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'session_start_time'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'report_service_entry_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'report_service_entry_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'card_number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'session_start'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'session_end'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_quantity'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'universal_service'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'service_price'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'workplace_id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x202d
sub rpcf_rpost_get_card_transactions {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x202d) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_rpost_get_card_transactions failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'since_time'});
		
	$spacket->setInt($href->{'till_time'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'transaction_data_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'transaction_data_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'instant'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'raw_transaction'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'traffic_value'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'workplace_number'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2030
sub rpcf_get_accountinfo {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2030) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_accountinfo failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'dealer_account_id'}  = $spacket->getInt();
		
	$rv->{'is_dealer'}  = $spacket->getInt();
		
	$rv->{'vat_rate'}  = $spacket->getDbl();
				
	$rv->{'sale_tax_rate'}  = $spacket->getDbl();
				
	$rv->{'comission_coefficient'}  = $spacket->getDbl();
				
	$rv->{'default_comission_value'}  = $spacket->getDbl();
				
	$rv->{'credit'}  = $spacket->getDbl();
				
	$rv->{'balance'}  = $spacket->getDbl();
				
	$rv->{'int_status'}  = $spacket->getInt();
		
	$rv->{'block_recalc_abon'}  = $spacket->getInt();
		
	$rv->{'block_recalc_prepaid'}  = $spacket->getInt();
		
	$rv->{'unlimited'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2031
sub rpcf_add_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2031) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		$href->{'is_basic'} = "1" unless exists $href->{'is_basic'};
	$spacket->setInt($href->{'is_basic'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		$href->{'account_name'} = "auto create account" unless exists $href->{'account_name'};
	$spacket->setStr($href->{'account_name'});$href->{'balance'} = "0.0" unless exists $href->{'balance'};
	$spacket->setDbl($href->{'balance'});$href->{'credit'} = "0.0" unless exists $href->{'credit'};
	$spacket->setDbl($href->{'credit'});$href->{'discount_period_id'} = "0" unless exists $href->{'discount_period_id'};
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'dealer_account_id'} = "0" unless exists $href->{'dealer_account_id'};
	$spacket->setInt($href->{'dealer_account_id'});
		$href->{'comission_coefficient'} = "0.0" unless exists $href->{'comission_coefficient'};
	$spacket->setDbl($href->{'comission_coefficient'});$href->{'default_comission_value'} = "0.0" unless exists $href->{'default_comission_value'};
	$spacket->setDbl($href->{'default_comission_value'});$href->{'is_dealer'} = "0" unless exists $href->{'is_dealer'};
	$spacket->setInt($href->{'is_dealer'});
		$href->{'vat_rate'} = "0.0" unless exists $href->{'vat_rate'};
	$spacket->setDbl($href->{'vat_rate'});$href->{'sale_tax_rate'} = "0.0" unless exists $href->{'sale_tax_rate'};
	$spacket->setDbl($href->{'sale_tax_rate'});$href->{'int_status'} = "1" unless exists $href->{'int_status'};
	$spacket->setInt($href->{'int_status'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'account_id'}  = $spacket->getInt();
		
	if ($rv->{'account_id'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to add account";
		return -1;				
								
	}
							

	return $rv;
}

# 0x2032
sub rpcf_save_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2032) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		$href->{'discount_period_id'} = "0" unless exists $href->{'discount_period_id'};
	$spacket->setInt($href->{'discount_period_id'});
		
	$spacket->setDbl($href->{'credit'});
	$spacket->setInt($href->{'is_blocked'});
		
	if ($href->{'is_blocked'} ne "0") {
		$href->{'block_start_date'} = $self->now() unless exists $href->{'block_start_date'};
	$spacket->setInt($href->{'block_start_date'});
		$href->{'block_end_date'} = $self->max_time() unless exists $href->{'block_end_date'};
	$spacket->setInt($href->{'block_end_date'});
		
	}
							
	$spacket->setInt($href->{'dealer_account_id'});
		
	$spacket->setDbl($href->{'vat_rate'});
	$spacket->setDbl($href->{'sale_tax_rate'});
	$spacket->setInt($href->{'int_status'});
		
	$spacket->setInt($href->{'block_recalc_abon'});
		
	$spacket->setInt($href->{'block_recalc_prepaid'});
		
	$spacket->setInt($href->{'unlimited'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2033
sub rpcf_get_user_account_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2033) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_account_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'account'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2034
sub rpcf_remove_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2034) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'ret_code'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2035
sub rpcf_get_sys_settings {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2035) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sys_settings failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'block_recalc_abon'}  = $spacket->getInt();
		
	$rv->{'block_recalc_prepaid'}  = $spacket->getInt();
		
	$rv->{'default_vat_rate'}  = $spacket->getDbl();
				

	return $rv;
}

# 0x2037
sub rpcf_block_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2037) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_block_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'is_blocked'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2101
sub rpcf_get_services_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2101) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_services_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'which_service'} = "-1" unless exists $href->{'which_service'};
	$spacket->setInt($href->{'which_service'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'services_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'services_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'service_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_comment_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_status_array'} = $spacket->getInt();
		
		$rv->{'service_status'} = ${$self->get_var("service_status_array")}[$i]->{'service_status_array'};
									
	if ($rv->{'service_status'} eq "2") {
		
	$rv->{'arr'}[$i]->{'tariff_name_array'} = $spacket->getStr();
			
	}
							
	if ($rv->{'service_status'} ne "2") {
		
		$rv->{'tariff_name_array'} = $self->get_var("");
									
	}
							
	} 
						

	return $rv;
}

# 0x2104
sub rpcf_get_periodic_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2104) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_periodic_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'pm_every_day'}  = $spacket->getInt();
		
	$rv->{'discount_method'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'param'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2105
sub rpcf_get_iptraffic_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2105) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_iptraffic_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'is_dynamic'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'pm_every_day'}  = $spacket->getInt();
		
	$rv->{'discount_method'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'null_service_prepaid'}  = $spacket->getInt();
		
	$rv->{'borders_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'borders_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getInt();
		
	if ($rv->{'tclass'} ne "4294967295") {
		
		$rv->{'borders_size_array'} = $self->get_var("borders_size");
									
			
	for (my $j = 0; $j < $rv->{'borders_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'border_cost'} = $spacket->getDbl();
				
	} 
						
	}
							
	} 
						
	$rv->{'prepaid_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'prepaid_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getInt();
		
	if ($rv->{'tclass'} ne "4294967295") {
		
	}
							
	} 
						
	$rv->{'tclass_id2group_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'tclass_id2group_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass_group_id'} = $spacket->getInt();
		
	} 
						
	$rv->{'service_data_parent_id'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2106
sub rpcf_add_periodic_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2106) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_periodic_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'fictive'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'param1'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2107
sub rpcf_add_iptraffic_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2107) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_iptraffic_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setInt($href->{'is_dynamic'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'param1'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		$href->{'borders_numbers'} = $self->size(tclass_b) unless exists $href->{'borders_numbers'};
	$spacket->setInt($href->{'borders_numbers'});
		
	for (my $i = 0; $i < $self->size(tclass_b); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'tclass_b'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'cost_b'});
	} 
						$href->{'prepaid_numbers'} = $self->size(tclass_p) unless exists $href->{'prepaid_numbers'};
	$spacket->setInt($href->{'prepaid_numbers'});
		
	for (my $i = 0; $i < $self->size(tclass_p); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'tclass_p'});
		
	} 
						$href->{'groups_numbers'} = $self->size(tcid) unless exists $href->{'groups_numbers'};
	$spacket->setInt($href->{'groups_numbers'});
		
	for (my $i = 0; $i < $self->size(tcid); $i++) {
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'tcid'});
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'tgid'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2108
sub rpcf_add_hotspot_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2108) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_hotspot_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'fictive'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setInt($href->{'is_dynamic'});
		
	$spacket->setInt($href->{'param1'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		
	$spacket->setInt($href->{'radius_sessions_limit'});
		
	$spacket->setDbl($href->{'recv_cost'});
	$spacket->setStr($href->{'rate_limit'});
	$spacket->setInt($href->{'allowed_net_size'});
		
	for (my $i = 0; $i < $href->{'allowed_net_size'}; $i++) {
		
	$spacket->setIP($href->{'arr_0'}[$i]->{'ip'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'value1'});
		
	} 
						
	$spacket->setInt($href->{'periodic_service_size'});
		
	for (my $i = 0; $i < $href->{'periodic_service_size'}; $i++) {
		
	$spacket->setDbl($href->{'arr_1'}[$i]->{'cost_p'});
	$spacket->setInt($href->{'arr_1'}[$i]->{'id_p'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'sid'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2109
sub rpcf_get_hotspot_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2109) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_hotspot_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'is_dynamic'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'pm_every_day'}  = $spacket->getInt();
		
	$rv->{'discount_method'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'null_service_prepaid'}  = $spacket->getInt();
		
	$rv->{'radius_sessions_limit'}  = $spacket->getInt();
		
	$rv->{'recv_cost'}  = $spacket->getDbl();
				
	$rv->{'rate_limit'}  = $spacket->getStr();
			
	$rv->{'hsd_allowed_net_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'hsd_allowed_net_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'allowed_net_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'allowed_net_value'} = $spacket->getInt();
		
	} 
						
	$rv->{'cost_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cost_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tr_time'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'param1'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'param2'} = $spacket->getInt();
		
	} 
						
	$rv->{'service_data_parent_id'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x210a
sub rpcf_get_once_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x210a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_once_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'is_parent_id'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x210b
sub rpcf_add_once_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x210b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_once_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setDbl($href->{'cost'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x210c
sub rpcf_get_dialup_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x210c) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_dialup_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'is_dynamic'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'pm_every_day'}  = $spacket->getInt();
		
	$rv->{'discount_method'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'pool_name'}  = $spacket->getStr();
			
	$rv->{'max_timeout'}  = $spacket->getInt();
		
	$rv->{'null_service_prepaid'}  = $spacket->getInt();
		
	$rv->{'radius_sessions_limit'}  = $spacket->getInt();
		
	$rv->{'login_prefix'}  = $spacket->getStr();
			
	$rv->{'cost_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cost_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tr_time'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'param'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	} 
						
	$rv->{'is_parent_id'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x210d
sub rpcf_add_dialup_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x210d) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_dialup_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setInt($href->{'is_dynamic'});
		$href->{'periodic_param'} = "0" unless exists $href->{'periodic_param'};
	$spacket->setInt($href->{'periodic_param'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setStr($href->{'pool_name'});
	$spacket->setInt($href->{'max_timeout'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		
	$spacket->setInt($href->{'radius_sessions_limit'});
		
	$spacket->setStr($href->{'login_prefix'});$href->{'cost_size'} = $self->size(range_id) unless exists $href->{'cost_size'};
	$spacket->setInt($href->{'cost_size'});
		
	for (my $i = 0; $i < $self->size(range_id); $i++) {
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'range_cost'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'range_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x210e
sub rpcf_remove_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x210e) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x210f
sub rpcf_get_hotspot_services_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x210f) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_hotspot_services_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'services_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'services_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'service_id'} = $spacket->getInt();
		
	if ($rv->{'service_id'} ne "4294967295") {
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'commect'} = $spacket->getStr();
			
	}
							
	} 
						

	return $rv;
}

# 0x2110
sub rpcf_get_fictive_services_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2110) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_fictive_services_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'services_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'services_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'service_id'} = $spacket->getInt();
		
	if ($rv->{'service_id'} ne "4294967295") {
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'commect'} = $spacket->getStr();
			
	}
							
	} 
						

	return $rv;
}

# 0x2115
sub rpcf_get_once_service_new {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2115) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_once_service_new failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'drop_from_group'}  = $spacket->getInt();
		
	$rv->{'is_parent_id'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2116
sub rpcf_add_once_service_new {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2116) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_once_service_new failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'drop_from_group'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2120
sub rpcf_add_periodic_service_batch {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2120) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_periodic_service_batch failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'fictive'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'parameter'});
		
	$spacket->setInt($href->{'discount_method_t'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2121
sub rpcf_add_iptraffic_service_batch {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2121) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_iptraffic_service_batch failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setInt($href->{'is_dynamic'});
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'parameter'});
		
	$spacket->setInt($href->{'discount_method_t'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		$href->{'num_of_borders'} = $self->size(tclass_b) unless exists $href->{'num_of_borders'};
	$spacket->setInt($href->{'num_of_borders'});
		
	for (my $i = 0; $i < $self->size(tclass_b); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'tclass_b'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'cost_b'});
	} 
						$href->{'num_of_prepaid'} = $self->size(tclass_p) unless exists $href->{'num_of_prepaid'};
	$spacket->setInt($href->{'num_of_prepaid'});
		
	for (my $i = 0; $i < $self->size(tclass_p); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'tclass_p'});
		
	} 
						$href->{'num_of_groups'} = $self->size(tcid) unless exists $href->{'num_of_groups'};
	$spacket->setInt($href->{'num_of_groups'});
		
	for (my $i = 0; $i < $self->size(tcid); $i++) {
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'tcid'});
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'gid'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2200
sub rpcf_get_time_ranges {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2200) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_time_ranges failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size_tr'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size_tr'}; $i++) {
		
	$rv->{'arr'}[$i]->{'range_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tr_name'} = $spacket->getStr();
			
	$rv->{'size_trd'}  = $spacket->getInt();
		
		$rv->{'size_trd_array'} = $self->get_var("size_trd");
									
			
	for (my $j = 0; $j < $rv->{'size_trd'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'sec_start'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'sec_stop'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'min_start'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'min_stop'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'hour_start'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'hour_stop'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'wday_start'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'wday_stop'} = $spacket->getInt();
		
	} 
						
	$rv->{'days_size'}  = $spacket->getInt();
		
		$rv->{'days_size_array'} = $self->get_var("days_size");
									
			
	for (my $j = 0; $j < $rv->{'days_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'internal_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'mday'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'month'} = $spacket->getInt();
		
	} 
						
	} 
						

	return $rv;
}

# 0x2201
sub rpcf_add_time_range {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2201) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_time_range failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'tr_name'});$href->{'size_trd'} = $self->size(sec_start) unless exists $href->{'size_trd'};
	$spacket->setInt($href->{'size_trd'});
		
	for (my $i = 0; $i < $self->size(sec_start); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'sec_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'sec_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'min_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'min_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'hour_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'hour_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'wday_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'wday_stop'});
		
	} 
						$href->{'days_size'} = $self->size(internal_id) unless exists $href->{'days_size'};
	$spacket->setInt($href->{'days_size'});
		
	for (my $i = 0; $i < $self->size(internal_id); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'internal_id'});
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'mday'});
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'month'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2202
sub rpcf_save_time_range {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2202) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_time_range failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tr_id'});
		
	$spacket->setStr($href->{'tr_name'});$href->{'size_trd'} = $self->size(sec_start) unless exists $href->{'size_trd'};
	$spacket->setInt($href->{'size_trd'});
		
	for (my $i = 0; $i < $self->size(sec_start); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'tr_entry_id'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'sec_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'sec_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'min_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'min_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'hour_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'hour_stop'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'wday_start'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'wday_stop'});
		
	} 
						$href->{'days_size'} = $self->size(internal_id) unless exists $href->{'days_size'};
	$spacket->setInt($href->{'days_size'});
		
	for (my $i = 0; $i < $self->size(internal_id); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'internal_id'});
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'mday'});
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'month'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2203
sub rpcf_del_time_range {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2203) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_time_range failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_range_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2300
sub rpcf_get_tclasses {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2300) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tclasses failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tclass_list_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'tclass_list_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'graph_color'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_display'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_fill'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2301
sub rpcf_add_tclass2 {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2301) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_tclass2 failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tclass_id'});
		
	$spacket->setStr($href->{'tclass_name'});
	$spacket->setInt($href->{'graph_color'});
		
	$spacket->setInt($href->{'is_display'});
		
	$spacket->setInt($href->{'is_fill'});
		
	$spacket->setInt($href->{'time_range_id'});
		
	$spacket->setInt($href->{'dont_save'});
		
	$spacket->setInt($href->{'local_traf_policy'});
		
	$spacket->setInt($href->{'tclass_count'});
		
	for (my $x = 0; $x < $href->{'tclass_count'}; $x++) {
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'saddr'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'saddr_mask'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'sport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'input'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'src_as'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'daddr'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'daddr_mask'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'dport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'output'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'dst_as'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'proto'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'tos'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'nexthop'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'tcp_flags'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'ip_from'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_sport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_input'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_src_as'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_dport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_output'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_dst_as'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_proto'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_tos'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_nexthop'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_tcp_flags'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'skip'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2302
sub rpcf_get_tclass {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2302) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tclass failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tclass_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tclass_name'}  = $spacket->getStr();
			
	$rv->{'graph_color'}  = $spacket->getInt();
		
	$rv->{'is_display'}  = $spacket->getInt();
		
	$rv->{'is_fill'}  = $spacket->getInt();
		
	$rv->{'time_range_id'}  = $spacket->getInt();
		
	$rv->{'dont_save'}  = $spacket->getInt();
		
	$rv->{'local_traf_policy'}  = $spacket->getInt();
		
	$rv->{'tclass_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'tclass_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'saddr'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'saddr_mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'sport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'input'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'src_as'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'daddr'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'daddr_mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'dport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'output'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'dst_as'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'proto'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tos'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nexthop'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tcp_flags'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'ip_from'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'use_sport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_input'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_src_as'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_dport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_output'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_dst_as'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_proto'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_tos'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_nexthop'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'use_tcp_flags'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'skip'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2303
sub rpcf_edit_tclass {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2303) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_tclass failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tclass_id'});
		
	$spacket->setStr($href->{'tclass_name'});
	$spacket->setInt($href->{'graph_color'});
		
	$spacket->setInt($href->{'is_display'});
		
	$spacket->setInt($href->{'is_fill'});
		
	$spacket->setInt($href->{'time_range_id'});
		
	$spacket->setInt($href->{'dont_save'});
		
	$spacket->setInt($href->{'local_traf_policy'});
		
	$spacket->setInt($href->{'tclass_count'});
		
	for (my $x = 0; $x < $href->{'tclass_count'}; $x++) {
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'saddr'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'saddr_mask'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'sport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'input'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'src_as'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'daddr'});
	$spacket->setIP($href->{'arr_0'}[$x]->{'daddr_mask'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'dport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'output'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'dst_as'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'proto'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'tos'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'nexthop'});
		
	$spacket->setIP($href->{'arr_0'}[$x]->{'ip_from'});
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_sport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_input'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_src_as'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_dport'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_output'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_dst_as'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_proto'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_tos'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_nexthop'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'use_tcp_flags'});
		
	$spacket->setInt($href->{'arr_0'}[$x]->{'skip'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2304
sub rpcf_remove_tclass {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2304) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_tclass failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tclass_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2400
sub rpcf_get_groups_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2400) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_groups_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'groups_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'group_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2401
sub rpcf_add_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2401) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setStr($href->{'group_name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2402
sub rpcf_edit_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2402) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setStr($href->{'group_name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2403
sub rpcf_get_sysgroups_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2403) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sysgroups_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'groups_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'group_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'group_info'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2404
sub rpcf_add_sysgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2404) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_sysgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setStr($href->{'group_name'});
	$spacket->setStr($href->{'group_info'});
	$spacket->setInt($href->{'num_of_fids'});
		
	for (my $i = 0; $i < $href->{'num_of_fids'}; $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'fid'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'allowed'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2405
sub rpcf_edit_sysgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2405) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_sysgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setStr($href->{'group_name'});
	$spacket->setStr($href->{'group_info'});$href->{'num_of_fids'} = $self->size(fid) unless exists $href->{'num_of_fids'};
	$spacket->setInt($href->{'num_of_fids'});
		
	for (my $i = 0; $i < $self->size(fid); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'fid'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'allowed'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2406
sub rpcf_get_sysgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2406) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sysgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'group_name'}  = $spacket->getStr();
			
	$rv->{'group_info'}  = $spacket->getStr();
			
	$rv->{'info_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'info_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'module'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'fids'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2407
sub rpcf_add_users_to_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2407) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_users_to_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(user_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'user_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2408
sub rpcf_remove_user_from_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2408) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_user_from_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'group_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2409
sub rpcf_get_group_info {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2409) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_group_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'group_name'}  = $spacket->getStr();
			
	$rv->{'user_id_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'user_id_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x240a
sub rpcf_group_op {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x240a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_group_op failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setInt($href->{'group_op'});
		
	if ($href->{'group_op'} eq "4") {
		
	$spacket->setInt($href->{'tpid_from'});
		
	$spacket->setInt($href->{'tpid_to'});
		
	}
							
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'error_code'}  = $spacket->getInt();
		
	$rv->{'error_msg'}  = $spacket->getStr();
			

	return $rv;
}

# 0x240b
sub rpcf_del_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x240b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'group_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x240c
sub rpcf_get_group_id_by_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x240c) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_group_id_by_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'group_name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'group_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2500
sub rpcf_get_contracts {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2500) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contracts failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'contracts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'contracts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'contracts_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'contracts_number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'contracts_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'contracts_text'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2550
sub rpcf_get_groups_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2550) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_groups_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'groups_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'group_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2551
sub rpcf_add_service_to_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2551) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_service_to_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "basic_account" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setInt($href->{'service_type'});
		$href->{'return_type'} = "dummy" unless exists $href->{'return_type'};
	$spacket->setStr($href->{'return_type'});$href->{'tariff_link_id'} = "0" unless exists $href->{'tariff_link_id'};
	$spacket->setInt($href->{'tariff_link_id'});
		
	if ($href->{'service_type'} eq "1") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'discount_date'} = $self->now() unless exists $href->{'discount_date'};
	$spacket->setInt($href->{'discount_date'});
		
	}
							
	if ($href->{'service_type'} eq "2") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		$href->{'unabon'} = "0" unless exists $href->{'unabon'};
	$spacket->setInt($href->{'unabon'});
		$href->{'unprepay'} = "0" unless exists $href->{'unprepay'};
	$spacket->setInt($href->{'unprepay'});
		
	}
							
	if ($href->{'service_type'} eq "3") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		$href->{'unabon'} = "0" unless exists $href->{'unabon'};
	$spacket->setInt($href->{'unabon'});
		$href->{'unprepay'} = "0" unless exists $href->{'unprepay'};
	$spacket->setInt($href->{'unprepay'});
		$href->{'ip_groups_count'} = $self->size(ip_address) unless exists $href->{'ip_groups_count'};
	$spacket->setInt($href->{'ip_groups_count'});
		
	for (my $i = 0; $i < $self->size(ip_address); $i++) {
		
	$spacket->setIP($href->{'arr_0'}[$i]->{'ip_address'});$href->{'arr_0'}[$i]->{'mask'} = "-1" unless exists $href->{'arr_0'}[$i]->{'mask'};
	$spacket->setIP($href->{'arr_0'}[$i]->{'mask'});$href->{'arr_0'}[$i]->{'mac'} = "dummy" unless exists $href->{'arr_0'}[$i]->{'mac'};
	$spacket->setStr($href->{'arr_0'}[$i]->{'mac'});$href->{'arr_0'}[$i]->{'iptraffic_login'} = "dummy" unless exists $href->{'arr_0'}[$i]->{'iptraffic_login'};
	$spacket->setStr($href->{'arr_0'}[$i]->{'iptraffic_login'});$href->{'arr_0'}[$i]->{'iptraffic_allowed_cid'} = "dummy" unless exists $href->{'arr_0'}[$i]->{'iptraffic_allowed_cid'};
	$spacket->setStr($href->{'arr_0'}[$i]->{'iptraffic_allowed_cid'});$href->{'arr_0'}[$i]->{'iptraffic_password'} = "dummy" unless exists $href->{'arr_0'}[$i]->{'iptraffic_password'};
	$spacket->setStr($href->{'arr_0'}[$i]->{'iptraffic_password'});$href->{'arr_0'}[$i]->{'ip_not_vpn'} = "0" unless exists $href->{'arr_0'}[$i]->{'ip_not_vpn'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'ip_not_vpn'});
		$href->{'arr_0'}[$i]->{'dont_use_fw'} = "0" unless exists $href->{'arr_0'}[$i]->{'dont_use_fw'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'dont_use_fw'});
		$href->{'arr_0'}[$i]->{'router_id'} = "0" unless exists $href->{'arr_0'}[$i]->{'router_id'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'router_id'});
		
	} 
						$href->{'quotas_count'} = $self->size(quota) unless exists $href->{'quotas_count'};
	$spacket->setInt($href->{'quotas_count'});
		
	for (my $i = 0; $i < $self->size(quota); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'tclass_id'});
		
	} 
						
	}
							
	if ($href->{'service_type'} eq "4") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setStr($href->{'hotspot_login'});
	$spacket->setStr($href->{'hotspot_password'});$href->{'unabon'} = "0" unless exists $href->{'unabon'};
	$spacket->setInt($href->{'unabon'});
		$href->{'unprepay'} = "0" unless exists $href->{'unprepay'};
	$spacket->setInt($href->{'unprepay'});
		
	}
							
	if ($href->{'service_type'} eq "5") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setStr($href->{'dialup_login'});$href->{'dialup_password'} = "dummy" unless exists $href->{'dialup_password'};
	$spacket->setStr($href->{'dialup_password'});$href->{'dialup_allowed_cid'} = "dummy" unless exists $href->{'dialup_allowed_cid'};
	$spacket->setStr($href->{'dialup_allowed_cid'});$href->{'dialup_allowed_csid'} = "dummy" unless exists $href->{'dialup_allowed_csid'};
	$spacket->setStr($href->{'dialup_allowed_csid'});$href->{'callback_enabled'} = "0" unless exists $href->{'callback_enabled'};
	$spacket->setInt($href->{'callback_enabled'});
		$href->{'unabon'} = "0" unless exists $href->{'unabon'};
	$spacket->setInt($href->{'unabon'});
		$href->{'unprepay'} = "0" unless exists $href->{'unprepay'};
	$spacket->setInt($href->{'unprepay'});
		
	}
							
	if ($href->{'service_type'} eq "6") {
		$href->{'slink_id'} = "0" unless exists $href->{'slink_id'};
	$spacket->setInt($href->{'slink_id'});
		$href->{'is_blocked'} = "0" unless exists $href->{'is_blocked'};
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		$href->{'unabon'} = "0" unless exists $href->{'unabon'};
	$spacket->setInt($href->{'unabon'});
		$href->{'unprepay'} = "0" unless exists $href->{'unprepay'};
	$spacket->setInt($href->{'unprepay'});
		$href->{'tel_numbers_count'} = $self->size(tel_number) unless exists $href->{'tel_numbers_count'};
	$spacket->setInt($href->{'tel_numbers_count'});
		
	for (my $i = 0; $i < $self->size(tel_number); $i++) {
		$href->{'arr_0'}[$i]->{'item_id'} = "0" unless exists $href->{'arr_0'}[$i]->{'item_id'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'item_id'});
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'tel_number'});
	$spacket->setStr($href->{'arr_0'}[$i]->{'tel_login'});
	$spacket->setStr($href->{'arr_0'}[$i]->{'tel_password'});$href->{'arr_0'}[$i]->{'tel_allowed_cid'} = "dummy" unless exists $href->{'arr_0'}[$i]->{'tel_allowed_cid'};
	$spacket->setStr($href->{'arr_0'}[$i]->{'tel_allowed_cid'});
	} 
						
	}
							
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	if ($rv->{'return_type'} eq "integer_return") {
		
	$rv->{'slink_id'}  = $spacket->getInt();
		
	if ($rv->{'slink_id'} eq "4294967295") {
		
		$self->{'obj'}->{'error'} = "unable to add service to user";
		return -1;				
								
	}
							
	}
							
	if ($rv->{'return_type'} ne "integer_return") {
		
	$rv->{'error_msg'}  = $spacket->getStr();
			
	if ($rv->{'error_msg'} ne "") {
		
		$self->{'obj'}->{'error'} = "unable to add service to user";
		return -1;				
								
	}
							
	}
							

	return $rv;
}

# 0x2552
sub rpcf_add_group_to_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2552) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_group_to_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'group_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2555
sub rpcf_add_once_service_to_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2555) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_once_service_to_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setInt($href->{'tplink'});
		
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setInt($href->{'discount_date'});
		
	$spacket->setDbl($href->{'quantity'});
	$spacket->setInt($href->{'invoice_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getStr();
			

	return $rv;
}

# 0x2556
sub rpcf_get_once_service_link_new {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2556) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_once_service_link_new failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'discount_date'}  = $spacket->getInt();
		
	$rv->{'quantity'}  = $spacket->getDbl();
				
	$rv->{'invoice_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2600
sub rpcf_get_discount_periods {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2600) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_discount_periods failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'discount_periods_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'discount_periods_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'static_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'discount_period_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'start_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'end_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'periodic_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'custom_duration'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'next_discount_period_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'canonical_length'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x2601
sub rpcf_get_first_discount_period_id {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2601) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_first_discount_period_id failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2602
sub rpcf_get_discount_period {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2602) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_discount_period failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'discount_period_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'end_date'}  = $spacket->getInt();
		
	$rv->{'periodic_type'}  = $spacket->getInt();
		
	$rv->{'custom_duration'}  = $spacket->getInt();
		
	$rv->{'discounts_per_week'}  = $spacket->getInt();
		
	$rv->{'next_discount_period_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2603
sub rpcf_add_discount_period {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2603) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_discount_period failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setInt($href->{'start'});
		
	$spacket->setInt($href->{'expire'});
		
	$spacket->setInt($href->{'periodic_type_t'});
		
	$spacket->setInt($href->{'cd'});
		
	$spacket->setInt($href->{'di'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2604
sub rpcf_change_discount_period {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2604) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_change_discount_period failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'tlid'});
		
	$spacket->setInt($href->{'sample_dp'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getStr();
			

	return $rv;
}

# 0x2605
sub rpcf_add_discount_period_return {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2605) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_discount_period_return failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'static_id'} = "0" unless exists $href->{'static_id'};
	$spacket->setInt($href->{'static_id'});
		
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = "0" unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		$href->{'periodic_type'} = "3" unless exists $href->{'periodic_type'};
	$spacket->setInt($href->{'periodic_type'});
		$href->{'custom_duration'} = "86400" unless exists $href->{'custom_duration'};
	$spacket->setInt($href->{'custom_duration'});
		$href->{'discount_interval'} = "7" unless exists $href->{'discount_interval'};
	$spacket->setInt($href->{'discount_interval'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'discount_period_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2606
sub rpcf_expire_discount_period {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2606) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_expire_discount_period failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'dpid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2700
sub rpcf_get_all_services_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2700) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_all_services_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'slink_id_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'slink_id_count'}; $i++) {
		
	$rv->{'service_id'}  = $spacket->getInt();
		
	if ($rv->{'service_id'} ne "4294967295") {
		
		$rv->{'service_id_array'} = $self->get_var("service_id");
									
	$rv->{'arr'}[$i]->{'service_type_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'tariff_name_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_cost_array'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'slink_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'discount_period_id_array'} = $spacket->getInt();
		
	}
							
	if ($rv->{'service_id'} eq "4294967295") {
		
		$rv->{'service_id_array'} = $self->get_var("");
									
		$rv->{'service_type_array'} = $self->get_var("");
									
		$rv->{'service_name_array'} = $self->get_var("");
									
		$rv->{'tariff_name_array'} = $self->get_var("");
									
		$rv->{'service_cost_array'} = $self->get_var("");
									
		$rv->{'slink_id_array'} = $self->get_var("");
									
		$rv->{'discount_period_id_array'} = $self->get_var("");
									
	}
							
	} 
						

	return $rv;
}

# 0x2701
sub rpcf_get_periodic_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2701) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_periodic_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'discount_period_id'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'is_unabon_period'}  = $spacket->getInt();
		
	$rv->{'is_unprepay_period'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2702
sub rpcf_get_iptraffic_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2702) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_iptraffic_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'discount_period_id'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'unabon'}  = $spacket->getInt();
		
	$rv->{'unprepay'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		
	$rv->{'ip_groups_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'ip_groups_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'ip_address'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mac'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'iptraffic_login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'iptraffic_password'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'iptraffic_allowed_cid'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'ip_not_vpn'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'dont_use_fw'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'router_id'} = $spacket->getInt();
		
	} 
						
	$rv->{'quotas_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'quotas_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2703
sub rpcf_get_hotspot_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2703) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_hotspot_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'discount_period_id'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'password'}  = $spacket->getStr();
			
	$rv->{'is_unabon_period'}  = $spacket->getInt();
		
	$rv->{'is_unprepay_period'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2704
sub rpcf_get_once_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2704) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_once_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'discount_date'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2705
sub rpcf_get_dialup_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2705) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_dialup_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'discount_period_id'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'password'}  = $spacket->getStr();
			
	$rv->{'allowed_cid'}  = $spacket->getStr();
			
	$rv->{'allowed_csid'}  = $spacket->getStr();
			
	$rv->{'callback_enabled'}  = $spacket->getInt();
		
	$rv->{'is_unabon_period'}  = $spacket->getInt();
		
	$rv->{'is_unprepay_period'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2800
sub rpcf_get_ipzones_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2800) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ipzones_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'zones_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'zones_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'zone_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'zone_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2801
sub rpcf_add_ipzone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2801) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_ipzone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $href->{'count'}; $i++) {
		
	$spacket->setIP($href->{'arr_0'}[$i]->{'net'});
	$spacket->setIP($href->{'arr_0'}[$i]->{'mask'});
	$spacket->setIP($href->{'arr_0'}[$i]->{'gateaway'});
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x2802
sub rpcf_get_ipzone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2802) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ipzone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'name'}  = $spacket->getStr();
			
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'net'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'gateaway'} = $spacket->getIP();
					
	} 
						

	return $rv;
}

# 0x2810
sub rpcf_get_houses_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2810) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_houses_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'houses_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'houses_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'house_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'ip_zone_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'connect_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'post_code'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'country'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'region'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'city'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'street'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'building'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2811
sub rpcf_add_house {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2811) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_house failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'house_id'});
		
	$spacket->setInt($href->{'connect_date'});
		
	$spacket->setStr($href->{'post_code'});
	$spacket->setStr($href->{'country'});
	$spacket->setStr($href->{'region'});
	$spacket->setStr($href->{'city'});
	$spacket->setStr($href->{'street'});
	$spacket->setStr($href->{'number'});
	$spacket->setStr($href->{'building'});$href->{'count'} = $self->size(ipzone_id) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(ipzone_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'ipzone_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2812
sub rpcf_get_house {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2812) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_house failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'house_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'house_id'}  = $spacket->getInt();
		
	$rv->{'connect_date'}  = $spacket->getInt();
		
	$rv->{'post_code'}  = $spacket->getStr();
			
	$rv->{'country'}  = $spacket->getStr();
			
	$rv->{'region'}  = $spacket->getStr();
			
	$rv->{'city'}  = $spacket->getStr();
			
	$rv->{'street'}  = $spacket->getStr();
			
	$rv->{'number'}  = $spacket->getStr();
			
	$rv->{'building'}  = $spacket->getStr();
			
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'ipzone_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'ipzone_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2813
sub rpcf_get_free_ips_for_house {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2813) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_free_ips_for_house failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'house_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'ips_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'ips_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'ips_ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'zone_name'} = $spacket->getStr();
			
	} 
						
	$rv->{'error'}  = $spacket->getStr();
			

	return $rv;
}

# 0x2814
sub rpcf_get_ip_mac {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2814) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ip_mac failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'ip_mac_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'ip_mac_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x2900
sub rpcf_get_ipgroups_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x2900) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ipgroups_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'groups_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_size'}; $i++) {
		
	$rv->{'count'}  = $spacket->getInt();
		
		$rv->{'count_array'} = $self->get_var("count");
									
			
	for (my $j = 0; $j < $rv->{'count'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'mac'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'allowed_cid'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x2901
sub rpcf_add_ipgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2901) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_ipgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'ipgroup_id'});
		
	$spacket->setIP($href->{'ip'});
	$spacket->setIP($href->{'mask'});
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'password'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2902
sub rpcf_get_ipgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2902) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_ipgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'ipgroup_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'name'}  = $spacket->getStr();
			
	$rv->{'ipzone_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'ipzone_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'gateaway'} = $spacket->getIP();
					
	} 
						

	return $rv;
}

# 0x2910
sub rpcf_get_currency_list {
	my $spacket;
	my $self = shift; 
    
	if ($self->{'urfa'}->rpc_call(0x2910) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_currency_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
    
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'currency_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'currency_size'}; $i++) {
		
	$rv->{'id'}  = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'currency_brief_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'currency_full_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'percent'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'rates'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# 0x2911
sub rpcf_add_currency {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2911) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_currency failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'currency_brief_name'});
	$spacket->setStr($href->{'currency_full_name'});
	$spacket->setInt($href->{'date'});
		
	$spacket->setDbl($href->{'rate'});
	$spacket->setDbl($href->{'percent'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2912
sub rpcf_edit_currency {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2912) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_currency failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'currency_brief_name'});
	$spacket->setStr($href->{'currency_full_name'});
	$spacket->setInt($href->{'date'});
		
	$spacket->setDbl($href->{'rate'});
	$spacket->setDbl($href->{'percent'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x2913
sub rpcf_get_currency_rate_history {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2913) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_currency_rate_history failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'contracts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'contracts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'time'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'value'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# 0x2914
sub rpcf_get_currency_rate_rbc {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2914) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_currency_rate_rbc failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'rate'}  = $spacket->getDbl();
				
	$rv->{'error'}  = $spacket->getStr();
			

	return $rv;
}

# 0x2915
sub rpcf_remove_currency {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x2915) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_currency failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x3002
sub rpcf_service_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_service_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		$href->{'group_id'} = "0" unless exists $href->{'group_id'};
	$spacket->setInt($href->{'group_id'});
		$href->{'apid'} = "0" unless exists $href->{'apid'};
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		$href->{'time_end'} = $self->now() unless exists $href->{'time_end'};
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_count'}  = $spacket->getInt();
		
			
	for (my $j = 0; $j < $rv->{'accounts_count'}; $j++) {
		
	$rv->{'atr_size'}  = $spacket->getInt();
		
		$rv->{'atr_size_array'} = $self->get_var("atr_size");
									
			
	for (my $i = 0; $i < $rv->{'atr_size'}; $i++) {
		
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'discount_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'discount_period_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'discount'} = $spacket->getDbl();
				
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$i]->{'comment'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x3003
sub rpcf_payments_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_payments_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		$href->{'group_id'} = "0" unless exists $href->{'group_id'};
	$spacket->setInt($href->{'group_id'});
		$href->{'depricated'} = "0" unless exists $href->{'depricated'};
	$spacket->setInt($href->{'depricated'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'users_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'users_count'}; $i++) {
		
	$rv->{'atr_size'}  = $spacket->getInt();
		
		$rv->{'atr_size_array'} = $self->get_var("atr_size");
									
			
	for (my $j = 0; $j < $rv->{'atr_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'actual_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment_enter_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment_incurrency'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'currency_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'method'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'who_receved'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'admin_comment'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment_ext_number'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x3004
sub rpcf_blocks_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3004) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_blocks_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		$href->{'group_id'} = "0" unless exists $href->{'group_id'};
	$spacket->setInt($href->{'group_id'});
		$href->{'apid'} = "0" unless exists $href->{'apid'};
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		$href->{'time_end'} = $self->now() unless exists $href->{'time_end'};
	$spacket->setInt($href->{'time_end'});
		$href->{'show_all'} = "1" unless exists $href->{'show_all'};
	$spacket->setInt($href->{'show_all'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_count'}; $i++) {
		
	$rv->{'atr_size'}  = $spacket->getInt();
		
		$rv->{'atr_size_array'} = $self->get_var("atr_size");
									
			
	for (my $j = 0; $j < $rv->{'atr_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'start_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'expire_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'what_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'block_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'comment'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x3006
sub rpcf_payments_timed_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3006) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_payments_timed_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		$href->{'group_id'} = "0" unless exists $href->{'group_id'};
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	if ($rv->{'id'} ne "4294967295") {
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'first_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'last_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'burn_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'amount'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'already_discounted'} = $spacket->getDbl();
				
	}
							
	} 
						

	return $rv;
}

# 0x3008
sub rpcf_payments_report_owner {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3008) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_payments_report_owner failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		$href->{'time_start'} = "0" unless exists $href->{'time_start'};
	$spacket->setInt($href->{'time_start'});
		$href->{'time_end'} = $self->now() unless exists $href->{'time_end'};
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'rows_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'rows_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'actual_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment_enter_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'payment_incurrency'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'currency_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'method'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'who_receved'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'admin_comment'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'payment_ext_number'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x3009
sub rpcf_traffic_report_ex {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3009) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_traffic_report_ex failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'type'});
		
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'bytes_in_kbyte'}  = $spacket->getDbl();
				
	$rv->{'users_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'users_count'}; $i++) {
		
	$rv->{'atr_size'}  = $spacket->getInt();
		
		$rv->{'atr_size_array'} = $self->get_var("atr_size");
									
			
	for (my $j = 0; $j < $rv->{'atr_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'login'} = $spacket->getStr();
			
	if ($rv->{'type'} ne "0") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'add_param'} = $spacket->getInt();
		
	}
							
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'discount'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x3010
sub rpcf_get_tariffs_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x3010) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tariffs_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariffs_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'tariffs_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'create_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'who_create'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'change_create'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'who_change'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login_change'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'expire_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'balance_rollover'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x3011
sub rpcf_get_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3011) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tariff_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_name'}  = $spacket->getStr();
			
	$rv->{'tariff_create_date'}  = $spacket->getInt();
		
	$rv->{'who_create'}  = $spacket->getInt();
		
	$rv->{'who_create_login'}  = $spacket->getStr();
			
	$rv->{'tariff_change_date'}  = $spacket->getInt();
		
	$rv->{'who_change'}  = $spacket->getInt();
		
	$rv->{'who_change_login'}  = $spacket->getStr();
			
	$rv->{'tariff_expire_date'}  = $spacket->getInt();
		
	$rv->{'tariff_is_blocked'}  = $spacket->getInt();
		
	$rv->{'tariff_balance_rollover'}  = $spacket->getInt();
		
	$rv->{'services_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'services_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'service_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_type_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'comment_array'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'link_by_default_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_dynamic_array'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x3012
sub rpcf_add_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3012) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'balance_rollover'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tp_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x3013
sub rpcf_edit_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3013) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tp_id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'is_blocked'});
		
	$spacket->setInt($href->{'balance_rollover'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tp_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x3014
sub rpcf_add_service_to_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3014) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_service_to_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'parent_id'});
		
	$spacket->setStr($href->{'service_name'});
	$spacket->setInt($href->{'service_type'});
		
	$spacket->setStr($href->{'comment'});
	$spacket->setInt($href->{'link_by_default'});
		
	$spacket->setInt($href->{'is_dynamic'});
		
	if ($href->{'service_type'} eq "1") {
		
	$spacket->setDbl($href->{'cost'});
	}
							
	if ($href->{'service_type'} eq "2") {
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'periodic_type'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	}
							
	if ($href->{'service_type'} eq "3") {
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'periodic_type'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		$href->{'number_of_borders'} = $self->size(tlass_b) unless exists $href->{'number_of_borders'};
	$spacket->setInt($href->{'number_of_borders'});
		
	for (my $i = 0; $i < $self->size(tlass_b); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'tclass_b'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'cost_b'});
	} 
						$href->{'number_of_prepaid'} = $self->size(tclass_p) unless exists $href->{'number_of_prepaid'};
	$spacket->setInt($href->{'number_of_prepaid'});
		
	for (my $i = 0; $i < $self->size(tclass_p); $i++) {
		
	$spacket->setInt($href->{'arr_1'}[$i]->{'tclass_p'});
		
	} 
						$href->{'number_of_groups'} = $self->size(tcid) unless exists $href->{'number_of_groups'};
	$spacket->setInt($href->{'number_of_groups'});
		
	for (my $i = 0; $i < $self->size(tcid); $i++) {
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'tcid'});
		
	$spacket->setInt($href->{'arr_2'}[$i]->{'gid'});
		
	} 
						
	}
							
	if ($href->{'service_type'} eq "4") {
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'periodic_type'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		$href->{'count1'} = $self->size(cost) unless exists $href->{'count1'};
	$spacket->setInt($href->{'count1'});
		
	for (my $i = 0; $i < $self->size(cost); $i++) {
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'cost'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'id'});
		
	} 
						$href->{'count2'} = $self->size(net) unless exists $href->{'count2'};
	$spacket->setInt($href->{'count2'});
		
	for (my $i = 0; $i < $self->size(net); $i++) {
		
	$spacket->setIP($href->{'arr_1'}[$i]->{'net'});
	$spacket->setIP($href->{'arr_1'}[$i]->{'mask'});
	} 
						
	}
							
	if ($href->{'service_type'} eq "6") {
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'periodic_type'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'radius_sessions_limit'});
		$href->{'count'} = $self->size(directions) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(directions); $i++) {
		$href->{'arr_0'}[$i]->{'borders_count'} = $self->size(borders,i) unless exists $href->{'arr_0'}[$i]->{'borders_count'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'borders_count'});
		
	for (my $j = 0; $j < $self->size(borders,i); $j++) {
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'arr_0'}[$j]->{'borders'});
	} 
						
	$spacket->setInt($href->{'arr_0'}[$i]->{'directions'});
		$href->{'arr_0'}[$i]->{'timeranges_count'} = $self->size(timeranges,i) unless exists $href->{'arr_0'}[$i]->{'timeranges_count'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'timeranges_count'});
		
	for (my $j = 0; $j < $self->size(timeranges,i); $j++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'arr_1'}[$j]->{'timeranges'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'arr_1'}[$j]->{'timeranges'});
	} 
						
	} 
						
	$spacket->setDbl($href->{'fixed_call_cost'});
	}
							
	if ($href->{'service_type'} eq "5") {
		
	$spacket->setDbl($href->{'cost'});
	$spacket->setInt($href->{'periodic_type'});
		
	$spacket->setInt($href->{'discount_method'});
		
	$spacket->setInt($href->{'start_date'});
		
	$spacket->setInt($href->{'expire_date'});
		
	$spacket->setInt($href->{'null_service_prepaid'});
		
	$spacket->setStr($href->{'pool_name'});
	$spacket->setInt($href->{'max_timeout'});
		
	$spacket->setStr($href->{'login_prefix'});$href->{'count'} = $self->size(cost) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(cost); $i++) {
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'cost'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'id'});
		
	} 
						
	}
							
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x3015
sub rpcf_del_service_from_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3015) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_service_from_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tp_id'});
		
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x3017
sub rpcf_get_user_tariffs {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3017) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_tariffs failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_tariffs_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'user_tariffs_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tariff_current_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tariff_next_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'discount_period_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tariff_link_id_array'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x3018
sub rpcf_link_user_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3018) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_link_user_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'tariff_current'});
		$href->{'tariff_next'} = "tariff_current" unless exists $href->{'tariff_next'};
	$spacket->setInt($href->{'tariff_next'});
		
	$spacket->setInt($href->{'discount_period_id'});
		$href->{'tariff_link_id'} = "0" unless exists $href->{'tariff_link_id'};
	$spacket->setInt($href->{'tariff_link_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	if ($rv->{'tariff_link_id'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to link user tariff";
		return -1;				
								
	}
							

	return $rv;
}

# 0x3019
sub rpcf_unlink_user_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3019) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_unlink_user_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'tariff_link_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x301a
sub rpcf_get_tps_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x301a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tps_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'tpid'});
		
	$spacket->setInt($href->{'tplink'});
		
	$spacket->setInt($href->{'curr'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'service_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'sid'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'comment'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'slink'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'value'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x301b
sub rpcf_remove_tariff {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x301b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_tariff failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x301c
sub rpcf_get_tariffs_history {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x301c) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tariffs_history failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'aid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'th_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'th_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tariff_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'link_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'unlink_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tariff_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x301d
sub rpcf_get_tariff_id_by_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x301d) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tariff_id_by_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tid'}  = $spacket->getInt();
		

	return $rv;
}

# 0x3020
sub rpcf_general_report_new {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3020) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_general_report_new failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		$href->{'account_id'} = "0" unless exists $href->{'account_id'};
	$spacket->setInt($href->{'account_id'});
		$href->{'group_id'} = "0" unless exists $href->{'group_id'};
	$spacket->setInt($href->{'group_id'});
		$href->{'discount_period_id'} = "0" unless exists $href->{'discount_period_id'};
	$spacket->setInt($href->{'discount_period_id'});
		
	$spacket->setInt($href->{'start_date'});
		$href->{'end_date'} = $self->now() unless exists $href->{'end_date'};
	$spacket->setInt($href->{'end_date'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'incoming_rest'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_once'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_periodic'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_iptraffic'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_hotspot'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_dialup'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_telephony'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'tax'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_with_tax'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'payments'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'outgoing_rest'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# 0x3100
sub rpcf_get_payment_methods_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x3100) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_payment_methods_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'payments_list_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'payments_list_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x3101
sub rpcf_add_payment_method {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3101) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_payment_method failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x3102
sub rpcf_edit_payment_method {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3102) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_payment_method failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x3110
sub rpcf_add_payment_for_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3110) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_payment_for_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		$href->{'unused'} = "0" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		
	$spacket->setDbl($href->{'payment'});$href->{'currency_id'} = "810" unless exists $href->{'currency_id'};
	$spacket->setInt($href->{'currency_id'});
		$href->{'payment_date'} = $self->now() unless exists $href->{'payment_date'};
	$spacket->setInt($href->{'payment_date'});
		$href->{'burn_date'} = "0" unless exists $href->{'burn_date'};
	$spacket->setInt($href->{'burn_date'});
		$href->{'payment_method'} = "1" unless exists $href->{'payment_method'};
	$spacket->setInt($href->{'payment_method'});
		$href->{'admin_comment'} = "dummy" unless exists $href->{'admin_comment'};
	$spacket->setStr($href->{'admin_comment'});$href->{'comment'} = "dummy" unless exists $href->{'comment'};
	$spacket->setStr($href->{'comment'});$href->{'payment_ext_number'} = "dummy" unless exists $href->{'payment_ext_number'};
	$spacket->setStr($href->{'payment_ext_number'});$href->{'payment_to_invoice'} = "0" unless exists $href->{'payment_to_invoice'};
	$spacket->setInt($href->{'payment_to_invoice'});
		$href->{'turn_on_inet'} = "1" unless exists $href->{'turn_on_inet'};
	$spacket->setInt($href->{'turn_on_inet'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'payment_transaction_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x3111
sub rpcf_cancel_payment_for_account {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3111) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_cancel_payment_for_account failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'pay_t_id'});
		
	$spacket->setStr($href->{'com_for_user'});
	$spacket->setStr($href->{'com_for_admin'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x3113
sub rpcf_add_payment_for_account_notify {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x3113) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_payment_for_account_notify failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'param'});
		
	$spacket->setDbl($href->{'payment_incurrency'});
	$spacket->setInt($href->{'currency_id'});
		
	$spacket->setInt($href->{'actual_date'});
		
	$spacket->setInt($href->{'burn_time'});
		
	$spacket->setInt($href->{'method'});
		
	$spacket->setStr($href->{'admin_comment'});
	$spacket->setStr($href->{'comment'});
	$spacket->setStr($href->{'payment_ext_number'});
	$spacket->setInt($href->{'payment_to_invoice'});
		
	$spacket->setInt($href->{'turn_on_inet'});
		
	$spacket->setInt($href->{'notify'});
		
	$spacket->setStr($href->{'hash'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'payment_transaction_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4200
sub rpcf_card_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4200) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_card_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'pool_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'cpi_owners_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cpi_owners_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'owners'} = $spacket->getInt();
		
	} 
						
	$rv->{'info_size'}  = $spacket->getInt();
		
	$rv->{'time0'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'info_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'card_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'pool_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'secret'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'currency'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'expire'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'days'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_used'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tp_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_blocked'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x4201
sub rpcf_card_pool_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x4201) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_card_pool_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'info_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'info_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'pool_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'cards'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'cards_used'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'first_update'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'last_update'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x4202
sub rpcf_card_add {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4202) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_card_add failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'secret'});
	$spacket->setDbl($href->{'balance'});
	$spacket->setInt($href->{'currency'});
		
	$spacket->setInt($href->{'expire'});
		
	$spacket->setInt($href->{'days'});
		
	$spacket->setInt($href->{'is_used'});
		
	$spacket->setInt($href->{'tp_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4203
sub rpcf_card_pool_add {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4203) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_card_pool_add failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'pool_id'});
		
	$spacket->setInt($href->{'sec_size'});
		
	$spacket->setInt($href->{'delay'});
		
	$spacket->setInt($href->{'size'});
		
	$spacket->setDbl($href->{'balance'});
	$spacket->setInt($href->{'currency'});
		
	$spacket->setInt($href->{'expire'});
		
	$spacket->setInt($href->{'days'});
		
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setInt($href->{'random'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
			
	for (my $i = 0; $i < $rv->{'size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'count'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x4204
sub rpcf_block_card {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4204) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_block_card failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'card_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4205
sub rpcf_unblock_card {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4205) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_unblock_card failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'card_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4206
sub rpcf_move_expired_cards {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x4206) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_move_expired_cards failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4290
sub rpcf_delete_card_owner {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4290) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_card_owner failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'pool_id'});
		
	$spacket->setInt($href->{'owned_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4291
sub rpcf_add_card_owner {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4291) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_card_owner failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'pool_id'});
		
	$spacket->setInt($href->{'owned_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4400
sub rpcf_get_settings_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x4400) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_settings_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'values_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'values_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'value'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x4401
sub rpcf_add_setting {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4401) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_setting failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'variable'});
	$spacket->setStr($href->{'old_value'});
	$spacket->setStr($href->{'new_value'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4402
sub rpcf_edit_setting {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4402) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_setting failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'variable'});$href->{'param'} = "dummy" unless exists $href->{'param'};
	$spacket->setStr($href->{'param'});
	$spacket->setStr($href->{'new_value'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4403
sub rpcf_remove_setting {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4403) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_remove_setting failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4404
sub rpcf_get_setting {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4404) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_setting failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'variable'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'values_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'values_count'}; $i++) {
		
	$rv->{'value'}  = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x4405
sub rpcf_get_sys_users_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x4405) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sys_users_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'info_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'info_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'user_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'ip_address'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getIP();
					
	} 
						

	return $rv;
}

# 0x4406
sub rpcf_add_sys_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4406) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_sys_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'password'});
	$spacket->setIP($href->{'ip_address'});
	$spacket->setIP($href->{'mask'});
	$spacket->setInt($href->{'groups_size'});
		
	for (my $i = 0; $i < $self->size(group_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'group_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4407
sub rpcf_edit_sys_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4407) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_sys_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'password'});
	$spacket->setIP($href->{'ip_address'});
	$spacket->setIP($href->{'mask'});
	$spacket->setInt($href->{'groups_size'});
		
	for (my $i = 0; $i < $self->size(group_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'group_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x4408
sub rpcf_get_sysuser_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4408) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sysuser_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'login'}  = $spacket->getStr();
			

	return $rv;
}

# 0x4409
sub rpcf_get_sys_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4409) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sys_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'ip'}  = $spacket->getIP();
					
	$rv->{'mask'}  = $spacket->getIP();
					
	$rv->{'groups_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'group_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'group_info'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x440a
sub rpcf_whoami {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x440a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_whoami failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'my_uid'}  = $spacket->getInt();
		
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'user_ip'}  = $spacket->getIP();
					
	$rv->{'user_mask'}  = $spacket->getIP();
					
	$rv->{'system_group_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'system_group_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'system_group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'system_group_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'system_group_info'} = $spacket->getStr();
			
	} 
						
	$rv->{'allowed_fids_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'allowed_fids_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'module'} = $spacket->getStr();
			
	} 
						
	$rv->{'not_allowed_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'not_allowed_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id_not_allowed'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name_not_allowed'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'module_not_allowed'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x440b
sub rpcf_get_uaparam_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x440b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_uaparam_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'uparam_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'uparam_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'display_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'visible'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x440c
sub rpcf_add_uaparam {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x440c) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_uaparam failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setStr($href->{'display_name'});
	$spacket->setInt($href->{'visible'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x440d
sub rpcf_del_uaparam {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x440d) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_uaparam failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uaparam_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x440e
sub rpcf_edit_uaparam {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x440e) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_edit_uaparam failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setStr($href->{'display_name'});
	$spacket->setInt($href->{'visible'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x4410
sub rpcf_delete_sys_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x4410) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_sys_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5000
sub rpcf_get_messages_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5000) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_messages_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'filter'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'message_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'message_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'send_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'7022recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'sender_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'subject'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'message'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'mime'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'state'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5001
sub rpcf_add_message {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_message failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'receiver_id'});
		
	$spacket->setStr($href->{'subject'});
	$spacket->setStr($href->{'message'});
	$spacket->setStr($href->{'mime'});
	$spacket->setInt($href->{'is_for_all'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5002
sub rpcf_get_routers_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_routers_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'routers_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'routers_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'router_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'router_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'router_ip'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'password'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'router_comments'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'router_bin_ip'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5003
sub rpcf_put_router {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_router failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'router_id'});
		
	$spacket->setInt($href->{'router_type'});
		
	$spacket->setStr($href->{'router_ip'});
	$spacket->setStr($href->{'login'});
	$spacket->setStr($href->{'password'});
	$spacket->setStr($href->{'router_comments'});
	$spacket->setInt($href->{'router_bin_ip'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5004
sub rpcf_get_fwrules_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5004) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_fwrules_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'rules_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'rules_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'rule_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_for_all'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'uid'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'group_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tariff_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'rule_on'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'rule_off'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'rule_block'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'router_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'and_logic'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'add_user'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'edit_user'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'del_user'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5005
sub rpcf_put_fwrule {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5005) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_fwrule failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'rule_id'});
		
	$spacket->setInt($href->{'is_for_all'});
		
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'group_id'});
		
	$spacket->setInt($href->{'tariff_id'});
		
	$spacket->setInt($href->{'router_id'});
		
	$spacket->setInt($href->{'and_logic'});
		
	$spacket->setInt($href->{'add_user'});
		
	$spacket->setInt($href->{'edit_user'});
		
	$spacket->setInt($href->{'del_user'});
		
	$spacket->setStr($href->{'rule_on'});
	$spacket->setStr($href->{'rule_off'});
	$spacket->setStr($href->{'rule_block'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5006
sub rpcf_del_fwrule {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5006) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_fwrule failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'rule_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5007
sub rpcf_del_router {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5007) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_router failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'router_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5010
sub rpcf_get_version_info {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5010) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_version_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'name'}  = $spacket->getStr();
			
	$rv->{'country'}  = $spacket->getStr();
			
	$rv->{'region'}  = $spacket->getStr();
			
	$rv->{'city'}  = $spacket->getStr();
			
	$rv->{'address'}  = $spacket->getStr();
			
	$rv->{'email'}  = $spacket->getStr();
			
	$rv->{'tel'}  = $spacket->getStr();
			
	$rv->{'web'}  = $spacket->getStr();
			

	return $rv;
}

# 0x5011
sub rpcf_put_version_info {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5011) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_version_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	$spacket->setStr($href->{'country'});
	$spacket->setStr($href->{'region'});
	$spacket->setStr($href->{'city'});
	$spacket->setStr($href->{'address'});
	$spacket->setStr($href->{'email'});
	$spacket->setStr($href->{'tel'});
	$spacket->setStr($href->{'web'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5012
sub rpcf_get_nas_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5012) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_nas_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'nas_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'nas_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'nas_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'auth_secret'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'acct_secret'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x5013
sub rpcf_put_nas {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5013) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_nas failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'mode'});
		
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'nas_id'});
	$spacket->setInt($href->{'nas_type'});
		
	$spacket->setStr($href->{'auth_secret'});
	$spacket->setStr($href->{'acct_secret'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5014
sub rpcf_get_traffic_detailed {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5014) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_traffic_detailed failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'user_id'} = "0" unless exists $href->{'user_id'};
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'nf5a_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'nf5a_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'timestamp'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'saddr'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'daddr'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'d_pkt'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'d_oct'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'sport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'dport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tcp_flags'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'proto'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tos'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5015
sub rpcf_get_dhs_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5015) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_dhs_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'dhs_log_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'dhs_log_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'last_update_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'Called_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'Calling_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'framed_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_port'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'acct_session_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'nas_port_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'uname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'framed_protocol'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'acct_status_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'acct_term_cause'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'total_cost'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# 0x5016
sub rpcf_get_dhs_report_detail {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5016) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_dhs_report_detail failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'session_id'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'dhs_log_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'dhs_log_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'last_update_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'framed_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_port'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'acct_session_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'nas_port_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'uname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'framed_protocol'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'acct_status_type'} = $spacket->getInt();
		
	$rv->{'count'}  = $spacket->getInt();
		
		$rv->{'count_array'} = $self->get_var("count");
									
			
	for (my $j = 0; $j < $rv->{'count'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'trange_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'sum_cost'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x5017
sub rpcf_get_dealer_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5017) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_dealer_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'dealer_id'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'dt_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'dt_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'dealer_account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'comission'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'discount_transaction_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment_transaction_id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5018
sub rpcf_get_tel_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5018) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tel_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'apid'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'dhs_log_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'dhs_log_size'}; $i++) {
		
	$rv->{'count'}  = $spacket->getInt();
		
		$rv->{'count_array'} = $self->get_var("count");
									
			
	for (my $j = 0; $j < $rv->{'count'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'acct_sess_time_plus_recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'Called_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'Calling_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'nas_port'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'acct_session_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'nas_port_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'uname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'framed_protocol'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'nas_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'nas_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'acct_status_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'zone_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'did'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'dcause'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'sum_cost'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x5019
sub rpcf_get_nas {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5019) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_nas failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'nas_id'}  = $spacket->getStr();
			
	$rv->{'nas_type'}  = $spacket->getInt();
		
	$rv->{'nas_size'}  = $spacket->getInt();
		

	return $rv;
}

# 0x501a
sub rpcf_del_nas {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x501a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_nas failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x501b
sub rpcf_add_traffic_quota_to_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x501b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_traffic_quota_to_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5029
sub rpcf_update_message_state {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5029) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_update_message_state failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'mid'});
		
	$spacket->setInt($href->{'state'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5050
sub rpcf_get_directions {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5050) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_directions failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'prefix'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'create_date'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5051
sub rpcf_add_direction {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5051) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_direction failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'prefix'});
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5052
sub rpcf_get_tel_zones {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x5052) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tel_zones failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'zones_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'zones_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'create_date'} = $spacket->getInt();
		
	$rv->{'dirs_size'}  = $spacket->getInt();
		
		$rv->{'dirs_size_array'} = $self->get_var("dirs_size");
									
			
	for (my $j = 0; $j < $rv->{'dirs_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'dirs_id'} = $spacket->getInt();
		
	} 
						
	} 
						

	return $rv;
}

# 0x5053
sub rpcf_add_zone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5053) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_zone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5054
sub rpcf_add_direction_to_zone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5054) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_direction_to_zone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'zone_id'});
		$href->{'count'} = $self->size(dir_id) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(dir_id); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'dir_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5055
sub rpcf_add_telephony_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5055) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_telephony_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'parent_id'} = "0" unless exists $href->{'parent_id'};
	$spacket->setInt($href->{'parent_id'});
		$href->{'tariff_id'} = "0" unless exists $href->{'tariff_id'};
	$spacket->setInt($href->{'tariff_id'});
		$href->{'service_id'} = "0" unless exists $href->{'service_id'};
	$spacket->setInt($href->{'service_id'});
		
	$spacket->setStr($href->{'service_name'});$href->{'comment'} = "dummy" unless exists $href->{'comment'};
	$spacket->setStr($href->{'comment'});$href->{'link_by_default'} = "0" unless exists $href->{'link_by_default'};
	$spacket->setInt($href->{'link_by_default'});
		$href->{'cost'} = "0" unless exists $href->{'cost'};
	$spacket->setDbl($href->{'cost'});$href->{'discount_method'} = "1" unless exists $href->{'discount_method'};
	$spacket->setInt($href->{'discount_method'});
		$href->{'start_date'} = $self->now() unless exists $href->{'start_date'};
	$spacket->setInt($href->{'start_date'});
		$href->{'expire_date'} = $self->max_time() unless exists $href->{'expire_date'};
	$spacket->setInt($href->{'expire_date'});
		$href->{'radius_sessions_limit'} = "0" unless exists $href->{'radius_sessions_limit'};
	$spacket->setInt($href->{'radius_sessions_limit'});
		$href->{'count'} = $self->size(directions) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(directions); $i++) {
		$href->{'arr_0'}[$i]->{'borders_count'} = $self->size(borders,i) unless exists $href->{'arr_0'}[$i]->{'borders_count'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'borders_count'});
		
	for (my $j = 0; $j < $self->size(borders,i); $j++) {
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'arr_0'}[$j]->{'borders'});
	} 
						
	$spacket->setInt($href->{'arr_0'}[$i]->{'directions'});
		$href->{'arr_0'}[$i]->{'timeranges_count'} = $self->size(timeranges,i) unless exists $href->{'arr_0'}[$i]->{'timeranges_count'};
	$spacket->setInt($href->{'arr_0'}[$i]->{'timeranges_count'});
		
	for (my $j = 0; $j < $self->size(timeranges,i); $j++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'arr_1'}[$j]->{'timeranges'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'arr_1'}[$j]->{'timeranges'});
	} 
						
	} 
						$href->{'fixed_call_cost'} = "0" unless exists $href->{'fixed_call_cost'};
	$spacket->setDbl($href->{'fixed_call_cost'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5056
sub rpcf_get_telephony_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5056) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_telephony_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'service_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'comment'}  = $spacket->getStr();
			
	$rv->{'link_by_default'}  = $spacket->getInt();
		
	$rv->{'cost'}  = $spacket->getDbl();
				
	$rv->{'discount_method'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'radius_sessions_limit'}  = $spacket->getInt();
		
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'directions'} = $spacket->getInt();
		
	$rv->{'borders_count'}  = $spacket->getInt();
		
		$rv->{'borders_count_array'} = $self->get_var("borders_count");
									
			
	for (my $j = 0; $j < $rv->{'borders_count'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'cost'} = $spacket->getDbl();
				
	} 
						
	$rv->{'arr'}[$i]->{'timerange_count'} = $spacket->getInt();
		
		$rv->{'timerange_count_array'} = $self->get_var("timerange_count");
									
			
	for (my $j = 0; $j < $rv->{'timerange_count'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'timerange_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'cost'} = $spacket->getDbl();
				
	} 
						
	} 
						
	$rv->{'fixed_call_cost'}  = $spacket->getDbl();
				
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5057
sub rpcf_del_zone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5057) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_zone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'zone_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5058
sub rpcf_get_telephony_service_link {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5058) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_telephony_service_link failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_link_id'}  = $spacket->getInt();
		
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'discount_period_id'}  = $spacket->getInt();
		
	$rv->{'start_date'}  = $spacket->getInt();
		
	$rv->{'expire_date'}  = $spacket->getInt();
		
	$rv->{'unabon'}  = $spacket->getInt();
		
	$rv->{'unprepay'}  = $spacket->getInt();
		
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'parent_id'}  = $spacket->getInt();
		
	$rv->{'numbers_size'}  = $spacket->getInt();
		
			
	for (my $numbers = 0; $numbers < $rv->{'numbers_size'}; $numbers++) {
		
	$rv->{'arr'}[$numbers]->{'item_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$numbers]->{'number'} = $spacket->getStr();
			
	$rv->{'arr'}[$numbers]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$numbers]->{'password'} = $spacket->getStr();
			
	$rv->{'arr'}[$numbers]->{'allowed_cid'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x5059
sub rpcf_del_dir {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5059) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_dir failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'dir_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5060
sub rpcf_del_dir_from_zone {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5060) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_dir_from_zone failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'zone_id'});
		
	$spacket->setInt($href->{'dir_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5080
sub rpcf_copy_voip_price {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5080) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_copy_voip_price failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'src_id'});
		
	$spacket->setInt($href->{'dst_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x5090
sub rpcf_get_graph {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5090) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_graph failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'account_id'}  = $spacket->getInt();
		
	$rv->{'graph_data_size'}  = $spacket->getInt();
		
	if ($rv->{'graph_data_size'} ne "0") {
		
			
	for (my $i = 0; $i < $rv->{'graph_data_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'graph_param'} = $spacket->getInt();
		
	} 
						
	$rv->{'st_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'st_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass_name'} = $spacket->getStr();
			
	} 
						
	}
							

	return $rv;
}

# 0x5091
sub rpcf_get_graph_data_iptraffic {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5091) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_graph_data_iptraffic failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'traffic_discount_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'traffic_discount_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'time'} = $spacket->getInt();
		
	$rv->{'size'}  = $spacket->getInt();
		
		$rv->{'size_array'} = $self->get_var("size");
									
			
	for (my $j = 0; $j < $rv->{'size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'bytes'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x5092
sub rpcf_get_graph_data_dialup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5092) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_graph_data_dialup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'gdata_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'gdata_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	$rv->{'size'}  = $spacket->getInt();
		
		$rv->{'size_array'} = $self->get_var("size");
									
			
	for (my $j = 0; $j < $rv->{'size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'bytes'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x5093
sub rpcf_get_graph_data_telephony {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5093) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_graph_data_telephony failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'t_start'});
		
	$spacket->setInt($href->{'t_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'gdata_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'gdata_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	$rv->{'size'}  = $spacket->getInt();
		
		$rv->{'size_array'} = $self->get_var("size");
									
			
	for (my $j = 0; $j < $rv->{'size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'bytes'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x5100
sub rpcf_delete_slink {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5100) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_slink failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'error_code'}  = $spacket->getInt();
		
	if ($rv->{'error_code'} ne "0") {
		
		$self->{'obj'}->{'error'} = "unable to delete service link";
		return -1;				
								
	}
							

	return $rv;
}

# 0x5101
sub rpcf_delete_from_ipgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5101) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_from_ipgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setIP($href->{'ip_address'});$href->{'mask'} = "255.255.255.255" unless exists $href->{'mask'};
	$spacket->setIP($href->{'mask'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		
	if ($rv->{'result'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to delete IP-address from ipgroup";
		return -1;				
								
	}
							

	return $rv;
}

# 0x5102
sub rpcf_delete_from_ipgroup_by_ipgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5102) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_from_ipgroup_by_ipgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'ip_group_id'});
		
	$spacket->setIP($href->{'ip_address'});$href->{'mask'} = "255.255.255.255" unless exists $href->{'mask'};
	$spacket->setIP($href->{'mask'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		
	if ($rv->{'result'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to delete IP-address from ipgroup";
		return -1;				
								
	}
							

	return $rv;
}

# 0x5200
sub rpcf_add_to_ipgroup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5200) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_to_ipgroup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'ip_group_id'});
		
	$spacket->setIP($href->{'ip_address'});$href->{'mask'} = "255.255.255.255" unless exists $href->{'mask'};
	$spacket->setIP($href->{'mask'});$href->{'iptraffic_login'} = "dummy" unless exists $href->{'iptraffic_login'};
	$spacket->setStr($href->{'iptraffic_login'});$href->{'iptraffic_password'} = "dummy" unless exists $href->{'iptraffic_password'};
	$spacket->setStr($href->{'iptraffic_password'});$href->{'mac'} = "dummy" unless exists $href->{'mac'};
	$spacket->setStr($href->{'mac'});$href->{'iptraffic_allowed_cid'} = "dummy" unless exists $href->{'iptraffic_allowed_cid'};
	$spacket->setStr($href->{'iptraffic_allowed_cid'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		
	if ($rv->{'result'} eq "0") {
		
		$self->{'obj'}->{'error'} = "unable to add IP-address to ipgroup";
		return -1;				
								
	}
							

	return $rv;
}

# 0x5500
sub rpcf_get_prepaid_units {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5500) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_prepaid_units failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'bytes_in_mbyte'}  = $spacket->getInt();
		
	$rv->{'pinfo_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'pinfo_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x5501
sub rpcf_put_prepaid_units {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5501) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_prepaid_units failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setInt($href->{'tclass_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x5511
sub rpcf_put_unif_iptr {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x5511) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_unif_iptr failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'count'} = $self->size(login) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(login); $i++) {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'login'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'ipid'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'tclass'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'d_oct'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x6001
sub rpcf_put_banks {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x6001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_put_banks failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	$href->{'banks_size'} = $self->size(bic) unless exists $href->{'banks_size'};
	$spacket->setInt($href->{'banks_size'});
		
	for (my $i = 0; $i < $self->size(bic); $i++) {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'bic'});
	$spacket->setStr($href->{'arr_0'}[$i]->{'name'});
	$spacket->setStr($href->{'arr_0'}[$i]->{'city'});
	$spacket->setStr($href->{'arr_0'}[$i]->{'kschet'});
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x6002
sub rpcf_get_banks {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x6002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_banks failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'banks_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'banks_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'bic'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'city'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'kschet'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x6003
sub rpcf_del_bank {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x6003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_bank failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'bank_id'});
		
	$spacket->setStr($href->{'bic'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7000
sub rpcf_get_contract_templates {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x7000) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contract_templates failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'usr_templates_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'usr_templates_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'contract_number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'template_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x7001
sub rpcf_add_contract_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_contract_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'contract_number'});
	$spacket->setInt($href->{'_date'});
		
	$spacket->setStr($href->{'text'});
	$spacket->setStr($href->{'template_name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7002
sub rpcf_update_contract_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_update_contract_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'contract_number'});
	$spacket->setInt($href->{'_date'});
		
	$spacket->setStr($href->{'text'});
	$spacket->setStr($href->{'template_name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7003
sub rpcf_delete_contract_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_contract_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7004
sub rpcf_add_contract {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7004) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_contract failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'contract_number'});
	$spacket->setInt($href->{'date'});
		$href->{'count_i'} = $self->size(contr_block) unless exists $href->{'count_i'};
	$spacket->setInt($href->{'count_i'});
		
	for (my $i = 0; $i < $self->size(contr_block); $i++) {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'contr_block'});
	} 
						
	$spacket->setInt($href->{'contract_uid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7005
sub rpcf_update_contract {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7005) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_update_contract failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'contract_number'});
	$spacket->setInt($href->{'date'});
		
	$spacket->setStr($href->{'text'});
	$spacket->setInt($href->{'contract_uid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7006
sub rpcf_delete_contract {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7006) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_contract failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7007
sub rpcf_get_contract_byid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7007) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contract_byid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'usr_contract_id'}  = $spacket->getInt();
		
	$rv->{'contract_number'}  = $spacket->getStr();
			
	$rv->{'date'}  = $spacket->getInt();
		
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'text'} = $spacket->getStr();
			
	} 
						
	$rv->{'usr_contract_uid'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7008
sub rpcf_get_contracts_listbyuid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7008) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contracts_listbyuid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'usr_contracts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'usr_contracts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'usr_contract_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'contract_number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x7009
sub rpcf_get_contract_byuidtid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7009) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contract_byuidtid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'tid'});
		
	$spacket->setStr($href->{'date_string'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'contract_number'}  = $spacket->getStr();
			
	$rv->{'date'}  = $spacket->getInt();
		
	$rv->{'text'}  = $spacket->getStr();
			
	$rv->{'uid'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7010
sub rpcf_get_contract_templatebyid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7010) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_contract_templatebyid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'usr_template_id'}  = $spacket->getInt();
		
	$rv->{'contract_number'}  = $spacket->getStr();
			
	$rv->{'date'}  = $spacket->getInt();
		
	$rv->{'text'}  = $spacket->getStr();
			
	$rv->{'template_name'}  = $spacket->getStr();
			

	return $rv;
}

# 0x7020
sub rpcf_add_doc_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7020) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_doc_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type_id'});
		
	$spacket->setInt($href->{'doc_template_id'});
		
	$spacket->setStr($href->{'doc_name'});
	$spacket->setStr($href->{'doc_text'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7021
sub rpcf_save_doc_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7021) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_doc_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type_id'});
		
	$spacket->setInt($href->{'needInsert'});
		
	$spacket->setInt($href->{'doc_template_id'});
		
	$spacket->setInt($href->{'doc_id'});
		
	$spacket->setStr($href->{'doc_name'});
	$spacket->setStr($href->{'doc_text'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7022
sub rpcf_get_doc_templates_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7022) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_doc_templates_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'doc_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'doc_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'def'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x7023
sub rpcf_get_doc_template_text {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7023) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_doc_template_text failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_template_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		
	if ($rv->{'id'} ne "0") {
		
	$rv->{'doc_text'}  = $spacket->getStr();
			
	$rv->{'landscape'}  = $spacket->getInt();
		
	}
							

	return $rv;
}

# 0x7024
sub rpcf_get_doc_types_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x7024) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_doc_types_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'doc_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# 0x7025
sub rpcf_set_default_doc_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7025) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_set_default_doc_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'template_id'});
		
	$spacket->setInt($href->{'doc_type'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7026
sub rpcf_delete_doc_template {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7026) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_delete_doc_template failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_templ_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7030
sub rpcf_generate_doc_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7030) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_generate_doc_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type_id'});
		$href->{'uid'} = "0" unless exists $href->{'uid'};
	$spacket->setInt($href->{'uid'});
		
	$spacket->setInt($href->{'base_id'});
		$href->{'doc_template_id'} = "0" unless exists $href->{'doc_template_id'};
	$spacket->setInt($href->{'doc_template_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'doc_template_id'}  = $spacket->getInt();
		
	$rv->{'static_id'}  = $spacket->getInt();
		
	if ($rv->{'static_id'} ne "0") {
		
	$rv->{'text_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'text_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'dynamic_text'} = $spacket->getStr();
			
	} 
						
	$rv->{'dynamic_landscape'}  = $spacket->getInt();
		
	}
							
	if ($rv->{'static_id'} eq "0") {
		
	$rv->{'dynamic_id'}  = $spacket->getInt();
		
	$rv->{'text_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'text_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'static_text'} = $spacket->getStr();
			
	} 
						
	$rv->{'static_landscape'}  = $spacket->getInt();
		
	}
							

	return $rv;
}

# 0x7031
sub rpcf_save_doc_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7031) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_doc_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_tmplate_id'});
		
	$spacket->setStr($href->{'doc_text'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7032
sub rpcf_get_doc_for_user {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7032) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_doc_for_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_data_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		
	if ($rv->{'id'} ne "0") {
		
	$rv->{'doc_text'}  = $spacket->getStr();
			
	$rv->{'landscape'}  = $spacket->getInt();
		
	}
							

	return $rv;
}

# 0x7033
sub rpcf_get_docs_list_for_aid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7033) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_docs_list_for_aid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'aid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'ret_code_count'}  = $spacket->getInt();
		
	if ($rv->{'ret_code_count'} ne "4294967295") {
		
			
	for (my $i = 0; $i < $rv->{'ret_code_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'doc_template_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'base_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'gen_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_sign'} = $spacket->getInt();
		
	} 
						
	}
							

	return $rv;
}

# 0x7034
sub rpcf_sign_doc {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7034) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_sign_doc failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7035
sub rpcf_del_doc {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7035) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_doc failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x7036
sub rpcf_get_docs_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7036) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_docs_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type'});
		
	$spacket->setInt($href->{'ground'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'ret_code_count'}  = $spacket->getInt();
		
	if ($rv->{'ret_code_count'} ne "4294967295") {
		
			
	for (my $i = 0; $i < $rv->{'ret_code_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'doc_template_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'base_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'gen_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'is_sign'} = $spacket->getInt();
		
	} 
						
	}
							

	return $rv;
}

# 0x7037
sub rpcf_update_templates_from_db {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x7037) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_update_templates_from_db failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x7038
sub rpcf_get_vendor_doc_text {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x7038) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_vendor_doc_text failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'doc_type'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'vendor_doc_text'}  = $spacket->getStr();
			

	return $rv;
}

# 0x8001
sub rpcf_get_invoices_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_invoices_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	$spacket->setInt($href->{'gid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accts_size'}; $i++) {
		
	$rv->{'count_of_invoice'}  = $spacket->getInt();
		
		$rv->{'count_of_invoice_array'} = $self->get_var("count_of_invoice");
									
	if ($rv->{'count_of_invoice'} ne "0") {
		
	$rv->{'arr'}[$i]->{'currency_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'currency_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'payment_rule'} = $spacket->getStr();
			
	}
							
			
	for (my $j = 0; $j < $rv->{'count_of_invoice'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'ext_num'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'invoice_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'uid'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment_transaction_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'expire_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'is_payed'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'is_printed'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'full_name'} = $spacket->getStr();
			
	if ($rv->{'is_payed'} ne "0") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'accInvcInfo_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'accInvcInfo_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'accInvcInfo_payed_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'payment_ext_number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'is_printed'} = $spacket->getInt();
		
	}
							
	$rv->{'entry_size'}  = $spacket->getInt();
		
		$rv->{'entry_size_array'} = $self->get_var("entry_size");
									
			
	for (my $x = 0; $x < $rv->{'entry_size'}; $x++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'invoice_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'discount_period_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'qnt'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'base'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'sum'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'arr'}[$x]->{'tax'} = $spacket->getDbl();
				
	} 
						
	if ($rv->{'entry_size'} ne "0") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'total_sum'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'total_tax'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'total_sum_plus_total_tax'} = $spacket->getDbl();
				
	}
							
	} 
						
	} 
						

	return $rv;
}

# 0x8002
sub rpcf_get_invc_lst_addpay {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_invc_lst_addpay failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'aid'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'binded_currency'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'inv_size'} = $spacket->getInt();
		
			
	for (my $j = 0; $j < $rv->{'inv_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'aid'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'ext_num'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'invoice_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'system_cur_sum'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'binded_cur_sum'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'total'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# 0x8003
sub rpcf_get_currency_rate_to_date {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_currency_rate_to_date failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'date'});
		
	$spacket->setInt($href->{'code'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getDbl();
				

	return $rv;
}

# 0x8004
sub rpcf_sendInvoice2mail {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8004) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_sendInvoice2mail failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'aid'});
		
	$spacket->setInt($href->{'invc_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x8011
sub rpcf_get_sup {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x8011) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_sup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'ur_adress'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'act_adress'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'inn'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'kpp'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'bank_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'fio_headman'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'fio_bookeeper'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'fio_headman_sh'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'fio_bookeeper_sh'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'name_sh'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'bank_bic'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'bank_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'bank_city'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'bank_kschet'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x8012
sub rpcf_save_sup {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8012) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_sup failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'name'});
	$spacket->setStr($href->{'ur_adress'});
	$spacket->setStr($href->{'act_adress'});
	$spacket->setStr($href->{'inn'});
	$spacket->setStr($href->{'kpp'});
	$spacket->setInt($href->{'bank_id'});
		
	$spacket->setStr($href->{'account'});
	$spacket->setStr($href->{'fio_headman'});
	$spacket->setStr($href->{'fio_bookeeper'});
	$spacket->setStr($href->{'fio_headman_sh'});
	$spacket->setStr($href->{'fio_bookeeper_sh'});
	$spacket->setStr($href->{'name_sh'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x8020
sub rpcf_get_user_instructions {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x8020) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_instructions failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'basic_account'}  = $spacket->getInt();
		
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'password'}  = $spacket->getStr();
			
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'group_size'}  = $spacket->getInt();
		
		$rv->{'group_size_array'} = $self->get_var("group_size");
									
			
	for (my $j = 0; $j < $rv->{'group_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'ulogin'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'password'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'mac'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x9000
sub rpcf_get_tech_param_by_uid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9000) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tech_param_by_uid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'size_tp'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'size_tp'}; $i++) {
		
	$rv->{'size_vec_ltp'}  = $spacket->getInt();
		
		$rv->{'size_vec_ltp_array'} = $self->get_var("size_vec_ltp");
									
			
	for (my $j = 0; $j < $rv->{'size_vec_ltp'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'type_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'type_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'param'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'reg_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'password'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# 0x9001
sub rpcf_del_tech_param {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_del_tech_param failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tpid'});
		
	$spacket->setStr($href->{'slink'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x9002
sub rpcf_get_tech_param_type {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x9002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_tech_param_type failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x9003
sub rpcf_get_techparam_slink_by_uid {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9003) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_techparam_slink_by_uid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'account_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# 0x9004
sub rpcf_add_tech_param {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9004) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_add_tech_param failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'type_id'});
		
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setStr($href->{'param'});
	$spacket->setInt($href->{'reg_date'});
		
	$spacket->setStr($href->{'passwd'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x9005
sub rpcf_save_tech_param {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9005) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_tech_param failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'type_id'});
		
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setInt($href->{'id'});
		
	$spacket->setStr($href->{'param'});
	$spacket->setInt($href->{'reg_date'});
		
	$spacket->setStr($href->{'passwd'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# 0x9020
sub rpcf_get_user_staticsets {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9020) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_staticsets failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count_of_sets'}  = $spacket->getInt();
		
	if ($rv->{'count_of_sets'} ne "0") {
		
	$rv->{'num_of_type_of_sets'}  = $spacket->getInt();
		
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'router_info'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'currency_id'} = $spacket->getInt();
		
	} 
						
	}
							

	return $rv;
}

# 0x9021
sub rpcf_get_user_othersets {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9021) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_user_othersets failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'type'} = $spacket->getInt();
		
	if ($rv->{'type'} eq "1") {
		
	$rv->{'switch_id'}  = $spacket->getInt();
		
	$rv->{'port'}  = $spacket->getInt();
		
	}
							
	if ($rv->{'type'} eq "3") {
		
	$rv->{'cur_id'}  = $spacket->getInt();
		
	$rv->{'name'}  = $spacket->getStr();
			
	}
							
	} 
						

	return $rv;
}

# 0x9022
sub rpcf_save_user_othersets {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x9022) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_save_user_othersets failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $href->{'count'}; $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'type'});
		
	if ($href->{'arr_0'}[$i]->{'type'} eq "1") {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'id'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'port'});
		
	}
							
	if ($href->{'arr_0'}[$i]->{'type'} eq "3") {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'currency_id'});
		
	}
							
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x10000
sub rpcf_get_periodic_component_of_cost {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x10000) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_periodic_component_of_cost failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'cost'}  = $spacket->getDbl();
				

	return $rv;
}

# 0x10001
sub rpcf_is_service_used {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x10001) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_is_service_used failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'links_count'}  = $spacket->getInt();
		

	return $rv;
}

# 0x10002
sub rpcf_get_bytes_in_kb {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x10002) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_bytes_in_kb failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'bytes_in_kb'}  = $spacket->getInt();
		

	return $rv;
}

# 0x10100
sub rpcf_set_radius_attr {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x10100) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_set_radius_attr failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	$spacket->setInt($href->{'st'});
		
	$spacket->setInt($href->{'cnt'});
		
	for (my $i = 0; $i < $href->{'cnt'}; $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'vendor'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'attr'});
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'param1'});
		
	if ($href->{'arr_0'}[$i]->{'param1'} eq "1") {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'cval'});
	}
							
	if ($href->{'arr_0'}[$i]->{'param1'} ne "1") {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'ival'});
		
	}
							
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# 0x10101
sub rpcf_get_radius_attr {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x10101) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_radius_attr failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'sid'});
		
	$spacket->setInt($href->{'st'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'radius_data_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'radius_data_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'vendor'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'attr'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'param1'} = $spacket->getInt();
		
	if ($rv->{'param1'} eq "0") {
		
	$rv->{'arr'}[$i]->{'val'} = $spacket->getInt();
		
	}
							
	if ($rv->{'param1'} eq "1") {
		
	$rv->{'arr'}[$i]->{'val'} = $spacket->getStr();
			
	}
							
	} 
						

	return $rv;
}

# 0x10200
sub rpcf_new_invoice {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x10200) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_new_invoice failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'gen_date'});
		$href->{'count'} = $self->size(name) unless exists $href->{'count'};
	$spacket->setInt($href->{'count'});
		
	for (my $i = 0; $i < $self->size(name); $i++) {
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'name'});
	$spacket->setDbl($href->{'arr_0'}[$i]->{'qnt'});
	$spacket->setDbl($href->{'arr_0'}[$i]->{'base_cost'});
	$spacket->setDbl($href->{'arr_0'}[$i]->{'sum_cost'});
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		

	return $rv;
}

# 0x11112
sub rpcf_get_core_time {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(0x11112) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_get_core_time failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'time'}  = $spacket->getInt();
		
	$rv->{'tzname'}  = $spacket->getStr();
			

	return $rv;
}

# -0x5502
sub rpcf_user5_get_unused_prepaid {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x5502) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_unused_prepaid failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'bytes_in_mbyte'}  = $spacket->getInt();
		
	$rv->{'links_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'links_size'}; $i++) {
		
	$rv->{'pinfo_size'}  = $spacket->getInt();
		
		$rv->{'pinfo_size_array'} = $self->get_var("pinfo_size");
									
			
	for (my $j = 0; $j < $rv->{'pinfo_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'id'} = $spacket->getInt();
		
	} 
						
	} 
						

	return $rv;
}

# -0x4205
sub rpcf_user5_card_payment {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4205) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_card_payment failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'account_id'});
		
	$spacket->setInt($href->{'card_id'});
		
	$spacket->setStr($href->{'secret'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x4099
sub rpcf_user5_get_tel_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4099) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_tel_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_size'}; $i++) {
		
	$rv->{'dhs_log_size'}  = $spacket->getInt();
		
		$rv->{'dhs_log_size_array'} = $self->get_var("dhs_log_size");
									
			
	for (my $j = 0; $j < $rv->{'dhs_log_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'recv_date_plus_acct_sess_time'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'acct_sess_time'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'Calling_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'Called_Station_Id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'dname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'total_cost'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# -0x4055
sub rpcf_user5_get_accounts {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4055) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_accounts failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'accounts_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'accounts_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'balance'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'credit'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# -0x4039
sub rpcf_user5_get_tariff_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4039) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_tariff_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'tariff_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tariff_name'}  = $spacket->getStr();
			

	return $rv;
}

# -0x4038
sub rpcf_user5_get_remaining_prepaid_traffic {
	my $spacket;
	my $self = shift; 
    
	if ($self->{'urfa'}->rpc_call(-0x4038) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_remaining_prepaid_traffic failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
    
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# -0x4037
sub rpcf_user5_get_currency_list {
	my $spacket;
	my $self = shift; 
    
	if ($self->{'urfa'}->rpc_call(-0x4037) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_currency_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
    
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'currency_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'currency_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'currency_brief_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'currency_full_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'percent'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'rates'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# -0x4034
sub rpcf_user5_add_mime_message {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4034) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_add_mime_message failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'subject'});
	$spacket->setStr($href->{'message'});
	$spacket->setStr($href->{'mime'});
	$spacket->setInt($href->{'state'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x4033
sub rpcf_user5_mime_messages_list_to_now {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4033) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_mime_messages_list_to_now failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'time_end'}  = $spacket->getInt();
		
	$rv->{'messages_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'messages_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'send_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'subject'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'message'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'mime'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'state'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# -0x4032
sub rpcf_user5_mime_messages_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4032) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_mime_messages_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'messages_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'messages_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'send_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'subject'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'message'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'mime'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'state'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# -0x4031
sub rpcf_user5_traffic_report_detail {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4031) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_traffic_report_detail failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'limit_size'});
		
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'nf5a_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'nf5a_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'timestamp'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'sname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tcd_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'saddr'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'daddr'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'d_pkt'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'d_okt'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'sport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'dport'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tcp_flags'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'proto'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tos'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# -0x4030
sub rpcf_user5_switch_internet_on_disconnect {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4030) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_switch_internet_on_disconnect failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'on'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x402e
sub rpcf_user5_get_discount_period_info {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x402e) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_discount_period_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		
	$rv->{'begin'}  = $spacket->getInt();
		
	$rv->{'end'}  = $spacket->getInt();
		
	$rv->{'periodic_type'}  = $spacket->getInt();
		
	$rv->{'next_discount_period_id'}  = $spacket->getInt();
		
	$rv->{'discount_interval'}  = $spacket->getInt();
		
	$rv->{'canonical_len'}  = $spacket->getInt();
		
	$rv->{'custom_duration'}  = $spacket->getInt();
		
	$rv->{'static_id'}  = $spacket->getInt();
		

	return $rv;
}

# -0x402b
sub rpcs_user5_get_services_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x402b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcs_user5_get_services_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'service_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_type'}  = $spacket->getInt();
		
	$rv->{'service_id'}  = $spacket->getInt();
		
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'service_comment'}  = $spacket->getStr();
			
	$rv->{'periodic_cost'}  = $spacket->getDbl();
				

	return $rv;
}

# -0x4029
sub rpcf_user5_tpayment {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4029) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_tpayment failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'is_exist'}  = $spacket->getInt();
		
	if ($rv->{'is_exist'} ne "0") {
		
	$rv->{'first_payment_time'}  = $spacket->getInt();
		
	$rv->{'last_payment_date'}  = $spacket->getInt();
		
	$rv->{'time2burn'}  = $spacket->getInt();
		
	$rv->{'payment_value'}  = $spacket->getDbl();
				
	$rv->{'already_discounted'}  = $spacket->getDbl();
				
	}
							

	return $rv;
}

# -0x4028
sub rpcf_user5_messages_list_to_now {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4028) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_messages_list_to_now failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'time_end'}  = $spacket->getInt();
		
	$rv->{'messages_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'messages_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'send_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'subject'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'message'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# -0x4027
sub rpcf_user5_get_prepaid_and_downloaded {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4027) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_prepaid_and_downloaded failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'bytes_in_mbyte'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'1000'}; $i++) {
		
	$rv->{'unk1'}  = $spacket->getInt();
		
	if ($rv->{'unk1'} eq "1") {
		
	$rv->{'iptraffic_service_name'}  = $spacket->getStr();
			
			
	for (my $j = 0; $j < $rv->{'1000'}; $j++) {
		
	$rv->{'unk2'}  = $spacket->getInt();
		
	if ($rv->{'unk2'} eq "1") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'old_tclass_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'old_tclass_name_array'} = $spacket->getStr();
			
	}
							
	if ($rv->{'unk2'} eq "0") {
		
	}
							
	} 
						
			
	for (my $j = 0; $j < $rv->{'1000'}; $j++) {
		
	$rv->{'unk2'}  = $spacket->getInt();
		
	if ($rv->{'unk2'} eq "1") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'tclass_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'tclass_name_array'} = $spacket->getStr();
			
	}
							
	if ($rv->{'unk2'} eq "0") {
		
	}
							
	} 
						
			
	for (my $j = 0; $j < $rv->{'1000'}; $j++) {
		
	$rv->{'unk2'}  = $spacket->getInt();
		
	if ($rv->{'unk2'} eq "1") {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'downloaded_tclass_id_array'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'downloaded_tclass_name_array'} = $spacket->getStr();
			
	}
							
	if ($rv->{'unk2'} eq "0") {
		
	}
							
	} 
						
	}
							
	if ($rv->{'unk1'} eq "0") {
		
	}
							
	} 
						

	return $rv;
}

# -0x4026
sub rpcf_user5_brief_report_for_wintray {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4026) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_brief_report_for_wintray failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_int_status'}  = $spacket->getInt();
		
	$rv->{'balance'}  = $spacket->getDbl();
				

	return $rv;
}

# -0x4025
sub rpcf_user5_change_password_service {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4025) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_change_password_service failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	$spacket->setInt($href->{'item_id'});
		
	$spacket->setStr($href->{'old_password'});
	$spacket->setStr($href->{'new_password'});
	$spacket->setStr($href->{'new_password_ret'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'status'}  = $spacket->getInt();
		

	return $rv;
}

# -0x4024
sub rpcf_user5_get_services_info {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4024) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_services_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'slink_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'service_type'}  = $spacket->getInt();
		
	$rv->{'service_id'}  = $spacket->getInt();
		
	$rv->{'service_name'}  = $spacket->getStr();
			
	$rv->{'tariff_id'}  = $spacket->getInt();
		
	$rv->{'discounted_in_curr_period'}  = $spacket->getDbl();
				
	$rv->{'cost'}  = $spacket->getDbl();
				
	if ($rv->{'service_type'} eq "3") {
		
	$rv->{'bytes_in_mbyte'}  = $spacket->getInt();
		
	$rv->{'iptsl_downloaded_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'iptsl_downloaded_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getStr();
			
	} 
						
	$rv->{'iptsl_old_prepaid_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'iptsl_old_prepaid_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getStr();
			
	} 
						
	$rv->{'ipgroup_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'ipgroup_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'item_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'ip'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'mask'} = $spacket->getIP();
					
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	} 
						
	$rv->{'iptsd_borders_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'iptsd_borders_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'cost1'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'group_type'} = $spacket->getInt();
		
	} 
						
	$rv->{'iptsd_prepaid_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'iptsd_prepaid_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass_name_p'} = $spacket->getStr();
			
	} 
						
	}
							
	if ($rv->{'service_type'} eq "6") {
		
	$rv->{'tsl_numbers_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'tsl_numbers_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'number'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'login'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'allowed_cid'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'item_id'} = $spacket->getInt();
		
	} 
						
	}
							
	if ($rv->{'service_type'} ne "3") {
		
	if ($rv->{'service_type'} ne "6") {
		
	$rv->{'null_param'}  = $spacket->getInt();
		
	}
							
	}
							

	return $rv;
}

# -0x4023
sub rpcf_user5_get_services {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4023) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_services failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'links_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'links_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'tariff_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'discount_period'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discounted_in_curr_period'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# -0x4022
sub rpcf_user5_get_invoice_data {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4022) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_invoice_data failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'full_name'}  = $spacket->getStr();
			
	$rv->{'actual_address'}  = $spacket->getStr();
			
	$rv->{'juridical_address'}  = $spacket->getStr();
			
	$rv->{'basic_account'}  = $spacket->getInt();
		
	$rv->{'payment_recv'}  = $spacket->getStr();
			
	$rv->{'inn'}  = $spacket->getStr();
			
	$rv->{'bank_account'}  = $spacket->getStr();
			
	$rv->{'bank_name'}  = $spacket->getStr();
			
	$rv->{'bank_city'}  = $spacket->getStr();
			
	$rv->{'bank_bic'}  = $spacket->getStr();
			
	$rv->{'bank_ks'}  = $spacket->getStr();
			

	return $rv;
}

# -0x4021
sub rpcf_user5_change_password {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4021) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_change_password failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'old_password'});
	$spacket->setStr($href->{'new_password'});
	$spacket->setStr($href->{'new_password_ret'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'result'}  = $spacket->getInt();
		

	return $rv;
}

# -0x401e
sub rpcf_user5_get_service_id_by_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x401e) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_service_id_by_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		

	return $rv;
}

# -0x401c
sub rpcf_user5_get_user_group_list {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x401c) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_user_group_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'groups_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'groups_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	} 
						

	return $rv;
}

# -0x401b
sub rpcf_user5_get_group_id_by_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x401b) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_group_id_by_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'id'}  = $spacket->getInt();
		

	return $rv;
}

# -0x401a
sub rpcf_user5_get_tariff_id_by_name {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x401a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_tariff_id_by_name failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'name'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'tid'}  = $spacket->getInt();
		

	return $rv;
}

# -0x4018
sub rpcf_user5_traffic_report_group_by_ip {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4018) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_traffic_report_group_by_ip failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'unused'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'bytes_in_kbyte'} = $spacket->getDbl();
				
	$rv->{'ipid_count'}  = $spacket->getInt();
		
			
	for (my $j = 0; $j < $rv->{'ipid_count'}; $j++) {
		
	$rv->{'arr'}[$j]->{'ipid'} = $spacket->getIP();
					
	$rv->{'traffic_report_entry_size'}  = $spacket->getInt();
		
		$rv->{'traffic_report_entry_size_array'} = $self->get_var("traffic_report_entry_size");
									
			
	for (my $x = 0; $x < $rv->{'traffic_report_entry_size'}; $x++) {
		
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'tclass_name'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# -0x4017
sub rpcf_user5_dhs_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4017) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_dhs_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'dhs_log_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'dhs_log_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'slink_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'last_update_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'framed_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_port'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'acct_session_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'nas_port_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'uname'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'framed_protocol'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_ip'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'nas_id'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'acct_status_type'} = $spacket->getInt();
		
	$rv->{'dhs_sessions_detail_size'}  = $spacket->getInt();
		
		$rv->{'dhs_sessions_detail_size_array'} = $self->get_var("dhs_sessions_detail_size");
									
			
	for (my $j = 0; $j < $rv->{'dhs_sessions_detail_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'trange_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'sum_cost'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# -0x4015
sub rpcf_user5_add_message {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4015) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_add_message failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'subject'});
	$spacket->setStr($href->{'message'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x4014
sub rpcf_user5_messages_list {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4014) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_messages_list failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'messages_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'messages_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'send_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'recv_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'subject'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'message'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# -0x4013
sub rpcf_user5_blocks_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4013) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_blocks_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'blocks_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'blocks_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'start_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'expire_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'what_blocked'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'block_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'comment'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# -0x4012
sub rpcf_user5_payments_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4012) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_payments_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'account_id'}  = $spacket->getInt();
		
	$rv->{'atr_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'atr_size'}; $i++) {
		
	$rv->{'arr'}[$i]->{'actual_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment_enter_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'payment_incurrency'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'currency_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment_method_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'payment_method'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'comment'} = $spacket->getStr();
			
	} 
						

	return $rv;
}

# -0x4011
sub rpcf_user5_service_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4011) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_service_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'aids_size'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'aids_size'}; $i++) {
		
	$rv->{'asr_size'}  = $spacket->getInt();
		
		$rv->{'asr_size_array'} = $self->get_var("asr_size");
									
			
	for (my $j = 0; $j < $rv->{'asr_size'}; $j++) {
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'account_id'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'discount_date'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'discount'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'discount_with_tax'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'service_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'service_type'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'arr'}[$j]->{'comment'} = $spacket->getStr();
			
	} 
						
	} 
						

	return $rv;
}

# -0x4010
sub rpcf_user5_traffic_report_group {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4010) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_traffic_report_group failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		
	$spacket->setInt($href->{'time_end'});
		$href->{'unused'} = "2" unless exists $href->{'unused'};
	$spacket->setInt($href->{'unused'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'unused'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'bytes_in_kbyte'} = $spacket->getDbl();
				
	$rv->{'date_count'}  = $spacket->getInt();
		
			
	for (my $j = 0; $j < $rv->{'date_count'}; $j++) {
		
	$rv->{'arr'}[$j]->{'date'} = $spacket->getInt();
		
	$rv->{'rows_count'}  = $spacket->getInt();
		
		$rv->{'rows_count_array'} = $self->get_var("date_count");
									
			
	for (my $x = 0; $x < $rv->{'rows_count'}; $x++) {
		
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'class_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$j]->{'arr'}[$x]->{'discount'} = $spacket->getDbl();
				
	} 
						
	} 
						

	return $rv;
}

# -0x4009
sub rpcf_user5_traffic_report {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4009) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_traffic_report failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'time_start'});
		$href->{'time_end'} = $self->now() unless exists $href->{'time_end'};
	$spacket->setInt($href->{'time_end'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'bytes_in_kbyte'}  = $spacket->getDbl();
				
	$rv->{'rows_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'rows_count'}; $i++) {
		
	$rv->{'arr'}[$i]->{'tclass'} = $spacket->getInt();
		
	$rv->{'arr'}[$i]->{'tclass_name'} = $spacket->getStr();
			
	$rv->{'arr'}[$i]->{'base_cost'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discount'} = $spacket->getDbl();
				
	$rv->{'arr'}[$i]->{'discount_with_tax'} = $spacket->getDbl();
				
	} 
						

	return $rv;
}

# -0x4007
sub rpcf_user5_change_int_status {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x4007) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_change_int_status failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'int_status_recv'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x4006
sub rpcf_user5_get_user_info {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x4006) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_user_info failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'user_id'}  = $spacket->getInt();
		
	$rv->{'login'}  = $spacket->getStr();
			
	$rv->{'basic_account'}  = $spacket->getInt();
		
	$rv->{'balance'}  = $spacket->getDbl();
				
	$rv->{'credit'}  = $spacket->getDbl();
				
	$rv->{'is_blocked'}  = $spacket->getInt();
		
	$rv->{'create_date'}  = $spacket->getInt();
		
	$rv->{'last_change_date'}  = $spacket->getInt();
		
	$rv->{'who_create'}  = $spacket->getInt();
		
	$rv->{'who_change'}  = $spacket->getInt();
		
	$rv->{'is_juridical'}  = $spacket->getInt();
		
	$rv->{'full_name'}  = $spacket->getStr();
			
	$rv->{'juridical_address'}  = $spacket->getStr();
			
	$rv->{'actual_address'}  = $spacket->getStr();
			
	$rv->{'work_telephone'}  = $spacket->getStr();
			
	$rv->{'home_telephone'}  = $spacket->getStr();
			
	$rv->{'mobile_telephone'}  = $spacket->getStr();
			
	$rv->{'web_page'}  = $spacket->getStr();
			
	$rv->{'icq_number'}  = $spacket->getStr();
			
	$rv->{'tax_number'}  = $spacket->getStr();
			
	$rv->{'kpp_number'}  = $spacket->getStr();
			
	$rv->{'bank_id'}  = $spacket->getInt();
		
	$rv->{'bank_account'}  = $spacket->getStr();
			
	$rv->{'int_status'}  = $spacket->getInt();
		
	$rv->{'vat_rate'}  = $spacket->getDbl();
				

	return $rv;
}

# -0x202a
sub rpcf_user5_rpost_report_put {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x202a) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_rpost_report_put failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	$spacket->setInt($href->{'session_start'});
		
	$spacket->setStr($href->{'card_number'});$href->{'report_entry_count'} = $self->size(sid) unless exists $href->{'report_entry_count'};
	$spacket->setInt($href->{'report_entry_count'});
		
	for (my $i = 0; $i < $self->size(sid); $i++) {
		
	$spacket->setInt($href->{'arr_0'}[$i]->{'sid'});
		
	$spacket->setStr($href->{'arr_0'}[$i]->{'s_name'});
	$spacket->setDbl($href->{'arr_0'}[$i]->{'s_time'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'s_is_universal_service'});
		
	$spacket->setDbl($href->{'arr_0'}[$i]->{'s_cost'});
	$spacket->setDbl($href->{'arr_0'}[$i]->{'s_price'});
	$spacket->setInt($href->{'arr_0'}[$i]->{'wp_id'});
		
	} 
						
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	

	return $rv;
}

# -0x2027
sub rpcf_user5_get_remaining_seconds {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x2027) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_remaining_seconds failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'remaining_seconds'}  = $spacket->getInt();
		
	$rv->{'downloaded_seconds'}  = $spacket->getInt();
		

	return $rv;
}

# -0x2026
sub rpcf_user5_get_remaining_traffic {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(-0x2026) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_user5_get_remaining_traffic failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setInt($href->{'user_id'});
		
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'traffic_remaining_mb'}  = $spacket->getDbl();
				
	$rv->{'traffic_downloaded_mb'}  = $spacket->getDbl();
				

	return $rv;
}

# -0x0045
sub rpcf_core_version_user {
	my $spacket;
	my $self = shift; 
	if ($self->{'urfa'}->rpc_call(-0x0045) < 0) {
		$self->{'obj'}->{'error'} = "Call rpcf_core_version_user failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'version'}  = $spacket->getStr();
			

	return $rv;
}

# 0x12001
sub get_shape_param {
	my $spacket;
	my $self = shift; 
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;

	if ($self->{'urfa'}->rpc_call(0x12001) < 0) {
		$self->{'obj'}->{'error'} = "Call get_shape_param failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	
	$spacket->setStr($href->{'str_classes'});
	$spacket->setInt($href->{'vpn_only'});
		
	$spacket->setStr($href->{'group_id'});
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	
	$rv->{'unused'}  = $spacket->getInt();
		
	$rv->{'cmd_count'}  = $spacket->getInt();
		
			
	for (my $i = 0; $i < $rv->{'cmd_count'}; $i++) {
		
	$rv->{'account_id'}  = $spacket->getInt();
		
	$rv->{'ip'}  = $spacket->getInt();
		
	$rv->{'mask'}  = $spacket->getInt();
		
	$rv->{'speed'}  = $spacket->getInt();
		
	$rv->{'inet_status'}  = $spacket->getInt();
		
	} 
						

	return $rv;
}


1;
