#!/usr/bin/perl 


use constant VERSION => 35;

$|=1;
use URFA;
use strict;
use URFAClient;

my $urfa = new URFA();


my %data = (
	"host"		=> "127.0.0.1",
	"port"		=> 11758,
#	"port"		=> 443,
	"login" 	=> "init",
	"password"	=> "init"
);

if ($urfa->belive_me(%data) == -1) {
	die ("Can't init urfa client: ". $urfa->{'error'} . "\n");
}


my $client = new URFAClient($urfa);

my %args = (
	"select_type" => 1,
	"arr_0" => [
		{
		 "what_id" => 1,
		 "criteria_id" => 2,
		 "pattern" => "xx"	
		},
		{
		 "what_id" => 1,
		 "criteria_id" => 2,
		 "pattern" => "xx"	
		},
		{
		 "what_id" => 1,
		 "criteria_id" => 2,
		 "pattern" => "xx"	
		},
	
	]
);



#$client->rpcf_search_cards(\%args);


my %args2 = (
	"arr_0" => [
		{ "pole_code_array" => 17 },
		{ "pole_code_array" => 18 },
		{ "pole_code_array" => 19 },
	],
	"select_type" => 0,
	"arr_1" => [
		{
		 "what_id" => 2,
		 "criteria_id" => 1,
		 "pattern" => "test",
		}
	#	{
	#	 "what_id" => 33,
	#	 "criteria_id" => 1,
	#	 "pattern" => 555	
	#	},
	#	{
	#	 "what_id" => 2,
	#	 "criteria_id" => 1,
	#	 "data_pattern" => "xx"	
	#	},
		

	],

);

my %args3 = (
	"pole_code_array" => [ 17,18,19 ],
	"select_type" => 0,
        "arr_1" => [
                {
                 "what_id" => 2,
                 "criteria_id" => 1,
                 "pattern" => "test",
                }
	],
);

my $p;

#$p = $client->rpcf_search_users_new(\%args2);


my %args4 = (
	"user_id" => 0,
	"login" => "mylogin",
	"password" => "test-password",
	"full_name" => "Ivan Ivanov",
	"is_juridical" => "0",
	"jur_address" => "My addr",
	"act_address" => "My addr",
	"flat_number" => "22",
	"entrance" => "14",
	"floor" => "2",
	"district" => "Coml",
	"building" => "2",
	"passport" => "1443 44 Ovd",
	"work_tel" => "544-44-44",
	"home_tel" => "544-22-22",
	"mob_tel" =>  "111-11-11",
	"web_page" => "www.website.ru",
	"icq_number" => "111444566",
	"tax_number" => "22",
	"kpp_number" => "55",
	"email" => 'test@test.com',
	"bank_id" => "12",
	"bank_account" => "testacc",
	"comments" => "comments",
	"personal_manager" => "Andt",
	"connect_date" => "2009-09-09",
	"is_send_invoice" => "1",
	"advance_payment" => "0"
);

$p = $client->rpcf_add_user(\%args4);

print "id=". $p->{'user_id'}."\n";
my %args5 = (
	"user_id" => "",
);

$args5{'user_id'} = $p->{'user_id'};


$p = $client->rpcf_add_account(\%args5);


print "account id ".$p->{'account_id'}."\n";


