/*
diy Wiki

by Tim Pollmer - 2016

Code Teile von: #Hilfe von https://wiki.selfhtml.org/wiki/Perl/Module/CGI-Modul
*/

#!/usr/bin/perl -w
 
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
 
my $cgi = new CGI;

print $cgi->header();


 
 
 
if ($cgi->param('absenden')) {
                print $cgi->start_html(-title=>'Vorschau',
                                    -style=>{'src'=>'control.css'});
                anzeige($cgi);
                print $cgi->end_html();
} else {
                 print $cgi->start_html(-title=>'SEITE ERSTELLEN',
                                        -style=>{'src'=>'control.css'});
                 formular($cgi);
                 print $cgi->end_html();
                 
}

if($cgi->param('new')){
                 print $cgi->start_html(-title=>'NEW',
                                        -style=>{'src'=>'control.css'});
                 new($cgi);
                 print $cgi->end_html(); 
}

if ($cgi->param('delect')){
     print $cgi->start_html(-title=>'Loeschen',
                                        -style=>{'src'=>'control.css'});
                 delect($cgi);
                 print $cgi->end_html(); 

}



sub formular{
    print $cgi->start_form(),
                   $cgi->h1('Control Center'),
                   $cgi->hr,  
                   $cgi->div('<a href="start.html">&Uumlbersicht</a> <a href="index.pl">Neu laden</a>'),
                   $cgi->h2('Hier erstellst du eine neue Seite'),
                                                                                      #noch formular einfügen für seite erstellen 
                   $cgi->div('Gib den Dateinamen an'),
                  # $cgi->br,
                   $cgi->input({-name=>'seitname', value=>'Testseite.html'}),
                   $cgi->br,
                   $cgi->br,
                   $cgi->div('Gib den Namen der neuen Seite ein'),
                   $cgi->input({-name=>'sname', -css=>'tim'}),
                   $cgi->br,
                   $cgi->br,
                   $cgi->div('Gib den Code fuer die Seite ein'),
                   $cgi->textarea({-name=>'code', -columns =>50, -rows =>10}),
                   $cgi->br,
                   $cgi->submit(-name => 'new', -value =>'Seite erstellen'),   #andere Subs werden oben angesprochen  
               
  
                   
                   $cgi->br,
                   $cgi->br,
                   $cgi->br,
                   

                   $cgi->h2('Hier kannst du deine Webseite erweitern'),
                   $cgi->input({-name=>'bearbeiten', -value=>'Name der Datei'}),
                   $cgi->br,
                   $cgi->br,
                   $cgi->div('Gib deinen HTML Code ein: '),
                  
                   $cgi->textarea({-name =>'text', -columns =>50, -rows =>5}),
                   $cgi->br,
                   $cgi->submit(-name => 'absenden', -value =>'speichern'),  #den eingegebenen Text in einer Variable übergeben mittels cgi 
                   $cgi->reset(-value =>'verwerfen'),
                   $cgi->br,

               
                   $cgi->br,
                   $cgi->br,
                   $cgi->br,

                   $cgi->h2('Seite l&oumlschen'),
                   $cgi->input({-name=>'delect', -value=>'Name der Datei'}),
                   $cgi->br,
                   $cgi->submit(-name => 'delect', -value =>'entfernen'),  #den eingegebenen Text in einer Variable übergeben mittels cgi 
                   $cgi->reset(-value =>'Abbrechen'),
                   $cgi->br,
                   $cgi->br,
                   $cgi->br,
                   
          $cgi->end_form();
}




sub anzeige{
 
      if ($cgi->param('text')) {
         print $cgi->strong('Dein Code wird gespeichert und sieht so aus : <br>' .$cgi->param('text')),
         $cgi->br;
         $cgi->hr;
         go($cgi); #jetz die funktion aufrufen um den code in einer datei zu speichern und die datai auch erstellen
      }else{
         print $cgi->strong('Da wurde nix eingegeben'),
          
    }
}



sub go{
    
    my $outfile = $cgi->param('bearbeiten');

    open (FILE, ">> $outfile") || die "problem opening $outfile\n";
    print FILE $cgi->param('text');
    close(FILE);

    print '<a href="';
    print $outfile;
    print '">';
    print $outfile;
    print '</a> anzeigen';
}


sub new{
    my $name = $cgi->param('seitname');
    my $sname = $cgi->param('sname');

    #Datei erstellen 
    open (NEW, ">$name") or die print $!;
    print NEW $cgi->start_html(-title=>$sname,
                               -style=>{'src'=>'css.css'});
    print NEW '<h1>';
    print NEW $sname;
    print NEW '</h1>';
    print NEW '<hr>';
    print NEW '<a href="start.html">Startseite</a>';
    print NEW '<a href="index.pl">Erstellen</a>';
    print NEW '<a herf="';
    print NEW $sname;
    print NEW '">Neu Laden</a>';
    print NEW '<br><br><div>';
    print NEW $cgi->param('code');
    close(NEW);
    #Datei schließen 
    
    #AUSGABE zur Bestätigung 
    print "<br>";
    print '<big>INFO</big> Die ';
    print '<a href="';
    print $name;
    print '">';
    print $name ;
    
    print '</a>';
    print ' Seite wurde erstellt';

}


sub delect{

my $result;
$result = unlink ($cgi->param('delect'));
print '<class="info">Die Seite wurde gel&oumlscht</class>';
    
}


    
open (START, ">start.html");
print START '
<head>
<title>Home</title>
<link rel="stylesheet" type="text/css" href="control.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>';

print START '<h1>Home</h1><hr><p>Hier findest du die übersicht von allen Seiten.</p><a href="index.pl">Erstellen</a>';

my $filename;
foreach $filename (<*.html>) {     #soll alle html datein auflisten , ist als menü gedacht 
  print START '<div class="menu"><a href="';
  print START $filename;
  print START '">';
  print START $filename;
  print START '</a></div><br>';
}


my $filename;
foreach $filename (<*.htm>) {     #soll alle html datein auflisten , ist als menü gedacht 
  print START '<div class="menu"><a href="';
  print START $filename;
  print START '">';
  print START $filename;
  print START '</a></div><br>';
}

close(START);
