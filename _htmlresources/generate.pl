
# MIT License
#
# Copyright (c) 2025 Sigmund Straumland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



# Download Latest version of this script
# https://github.com/RobotSigmund/Doc-browser

# Download Perl here (you need this to run this script):
# https://strawberryperl.com/

# Download latest jsTree here (only needed if upgrade is required):
# https://github.com/vakata/jstree

my $jstree_location = '_htmlresources/jstree/jstree.min.js';
my $jstree_theme_location = '_htmlresources/jstree/themes/default/style.min.css';

# Download latest jQuery here (only needed if upgrade is required):
# https://jquery.com/download/

my $jquery_location = '_htmlresources/jquery/jquery-latest.min.js';

# Download latest Fuse.js here (only needed if upgrade is required):
# https://www.fusejs.io/

my $fuse_location = '_htmlresources/fuse.js/fuse.min.js';

my $docs_root_folder = 'Docs';
my $generator_version = '2025-03-16';



##### ##### No need to edit below this line ##### #####



# Set character encoding to utf-8
use utf8;
use open ':std', ':encoding(UTF-8)';

# Include windows related tools
use Win32;

# Force better practices
use strict;



# Global Node counter for jstree nodes
our $NODE_ID = 1;
# Global Node data array. It will be populated by traversing foldertree, and then
# used to generate index.html .
our(@DATA) = ();

print 'Reading data' . "\n";

# Scan folder
TraverseFolder('../' . $docs_root_folder, 0);

# Build JSON
print 'Building JSON' . "\n";

my $jstree_json = GenerateJstreeJson();
my $fuse_json = GenerateFuseJson();

# Build warning data
my $warnings = GenerateWarnings();

# Build HTML
print 'Building HTML' . "\n";

my $datetime = getDateTime();

# Read template file
my $html_template;
open(my $FILE, '<index1-template.html');
read($FILE, $html_template, -s $FILE);
close($FILE);

# Replace tags
my $version_header = GenerateVersionHeader();
$html_template =~ s/\%folderData\%/$jstree_json/;
$html_template =~ s/\%fileData\%/$fuse_json/;
$html_template =~ s/\%datetime\%/$datetime/;
$html_template =~ s/\%jstree_location\%/$jstree_location/;
$html_template =~ s/\%jstree_theme_location\%/$jstree_theme_location/;
$html_template =~ s/\%jquery_location\%/$jquery_location/;
$html_template =~ s/\%generator_version\%/$generator_version/;
$html_template =~ s/\%fuse_location\%/$fuse_location/;
$html_template =~ s/<head>/$version_header/;

# Generate array, split up absolute path for this script
my(@perlscript_path) = split(/[\/\\]/, $0);

# We set the foldername 3 levels up to project_title, should be project folder. Ex. "PXXXXX Customer Application"
my $project_title = $perlscript_path[$#perlscript_path-3];

$html_template =~ s/\%project_title\%/$project_title/g;

# Write file
open(my $FILE, '>../index.html');
print $FILE $html_template;
close($FILE);

# Build opening page
my $user = Win32::LoginName() || "Unknown";
my $usermachine = Win32::NodeName() || "Unknown";

# Read template file
my $html_template;
open(my $FILE, '<index2-template.html');
read($FILE, $html_template, -s $FILE);
close($FILE);

# Replace tags
$html_template =~ s/\%datetime\%/$datetime/;
$html_template =~ s/\%user\%/$user/;
$html_template =~ s/\%usermachine\%/$usermachine/;
$html_template =~ s/\%warnings\%/$warnings/;

# Write file
open(my $FILE, '>index.html');
print $FILE $html_template;
close($FILE);

print 'Done' . "\n";



sleep(3);
exit;



sub GenerateWarnings {
	my(@files);
	my $warnings;
	
	# Open config file
	open(my $FILE, '<warning_if_missing.cfg') or return '';
	
	# Loop through all entries
	LINE: while (my $line = <$FILE>) {
		chomp($line);
		
		# Skip if comment
		next if ($line =~ /^[\s\t]*#/);		
		# Skip if empty line
		next if ($line =~ /^[\s\t]*$/);
		
		# If we find something which looks valid we use it
		if ($line =~ /([^;]*);([^;]*);/i) {
			my $folder = $1;
			my $filest = $2;
			@files = split(/\|/, $filest);
			
			# Loop through filestructure data and look for entry
			foreach my $i (0..$#DATA) {
				my(undef, undef, $filename, $path, undef) = split(/;/, $DATA[$i]);

				foreach $filest (@files) {
					next LINE if (($path =~ /$folder/i) && ($filename =~ /$filest/i));
				}
			}
			
			# Missing entry so add to warnings
			$warnings .= 'Warning, required entry [' . $line . '] was not found in filestructure.'."</br>\n";
		}
	}
	close($FILE);
	
	return $warnings if ($warnings eq '');
	return '<p>' . "\n" . $warnings . '</p>' . "\n".'<p><i><small>Warnings can be removed by deleting _htmlresources/warning_if_missing.cfg.</small></i></p>' . "\n";
}



sub TraverseFolder {
	my($foldername, $parent_id) = @_;
	
	opendir(my $DIR, $foldername);
	foreach my $de (readdir($DIR)) {
		next if ($de eq '.');
		next if ($de eq '..');
		
		if (-d $foldername . '/' . $de) {
			# Subfolder, start recursion
			
			push(@DATA, $NODE_ID . ';Folder;' . $de . ';' . $foldername . '/' . $de . ';' . $parent_id);
			$NODE_ID++;
			TraverseFolder($foldername . '/' . $de, $NODE_ID - 1);
			
		} else {
			# File, store to data array
			
			# NODE_ID; Type; Filename; Path; Parent
			push(@DATA, $NODE_ID . ';File;' . $de . ';' . $foldername . '/' . $de . ';' . $parent_id);
			$NODE_ID++;
			
			print $foldername . '/' . $de . "\n";
		}
	}
	closedir($DIR);
}



sub GenerateJstreeJson {
	# Add a root node. All folders we find will be children of this node.
	my $json = '{ "id": "id0", "parent": "#", "text": "' . $docs_root_folder . '", "icon": "jstree-folder" }, ' . "\n";

	foreach my $i (0..$#DATA) {
		my($node_id, $type, $filename, $path, $parent_id) = split(/;/, $DATA[$i]);
		
		# Remove leading '../' from path
		$path = substr($path, 3, length($path) - 3);
		
		$json .= '{ "id": "id' . $node_id . '", "parent": "id' . $parent_id . '", "text": "' . $filename . '", ';
		if ($type eq 'Folder') {
			$json .= '"icon": "jstree-folder"';
		} else {
			$json .= '"icon": "jstree-file"';
			$json .= ', "a_attr": { "href": "' . $path . '" }';
		}
		$json .= ' }';
		if ($i < $#DATA) {
			$json .= ',' . "\n";
		}
	}
	return $json;
}



sub GenerateFuseJson {
	my $json;

	foreach my $i (0..$#DATA) {
		my($node_id, $type, $filename, $path, $parent_id) = split(/;/, $DATA[$i]);
		if ($type eq 'File') {
			$json .= '{ id: "id' . $node_id . '", name: "' . $filename . '", text: "' . $path . '" }';	
			$json .= ',' . "\n" if ($i < $#DATA);
		}
	}
	
	return $json;
}



sub GenerateVersionHeader {
	return '<head>' . "\n" . '<!--' . "\n\n" . 'Doc browser rev. ' . $generator_version . ' - https://github.com/RobotSigmund/Doc-browser' . "\n\n" . '-->' . "\n";
}



sub getDateTime {
	my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
	return sprintf("%04d-%02d-%02d %02d:%02d:%02d", ($year + 1900), ($mon + 1), $mday, $hour, $min, $sec);
}


