<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:output method="text" omit-xml-declaration="yes" indent="yes" />
<xsl:param name="boundary" />


<xsl:template match="/">
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
        for (my $i = 0; $i &lt; $total; $i++) {
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

<xsl:apply-templates select="/urfa/function" />

1;
</xsl:template>



<xsl:template match="function">
# <xsl:value-of select="@id" />
sub <xsl:value-of select="@name" /> {
	my $spacket;
	my $self = shift; <xsl:apply-templates select="input" mode="title" />
	if ($self->{'urfa'}->rpc_call(<xsl:value-of select="@id" />) &lt; 0) {
		$self->{'obj'}->{'error'} = "Call <xsl:value-of select="@name" /> failed";
		return -1;
	}

	$spacket = new Packet::Stream({
				sock => $self->{'urfa'}->{'sock'},
				version => VERSION
			});

	<xsl:apply-templates select="input" mode="main" />
	
	$spacket->write();
        my $data = $self->{'urfa'}->get_stream_data($spacket);
	if ($data == -1) {
		$self->{'error'} = "call failed";
		return -1;
	}

	<xsl:apply-templates select="output"  />

	return $rv;
}
</xsl:template>


<xsl:template match="input[count(*) > 0]" mode="title" >
	my $href = shift;
	my %rv = {};

	return -1 unless (%$href);
	$self->{'obj'} = $href;
	$self->{'rv'} = $rv;
</xsl:template>

<xsl:template name="procdef" >
	<xsl:param name="deep"/>
	<xsl:variable name="deepv">
	<xsl:choose><xsl:when test="not($deep)">$href</xsl:when>
	<xsl:otherwise><xsl:value-of select="$deep"/></xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isfunc">
	<xsl:if test="contains(@default,'(') and contains(@default,')')">1</xsl:if>
	</xsl:variable>
<xsl:choose><xsl:when test="@default != ''"><xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'} = <xsl:choose><xsl:when test="$isfunc != 1">"</xsl:when><xsl:otherwise>$self-></xsl:otherwise></xsl:choose><xsl:value-of select="@default" /><xsl:if test="$isfunc != 1">"</xsl:if> unless exists <xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'};</xsl:when><xsl:otherwise>
<xsl:if test="@default"><xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'} = "dummy" unless exists <xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'};</xsl:if></xsl:otherwise></xsl:choose>

</xsl:template>

<xsl:template match="input[count(*) > 0]" mode="main" name="input">
	<xsl:param name="deep"/>

	<xsl:variable name="deepv">
	<xsl:choose><xsl:when test="not($deep)">$href</xsl:when>
	<xsl:otherwise><xsl:value-of select="$deep"/></xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

	<xsl:for-each select="*">
		<xsl:choose>
		<xsl:when test="name() = 'integer'">
	<xsl:call-template name="procdef" ><xsl:with-param name="deep"><xsl:value-of select="$deepv" /></xsl:with-param></xsl:call-template>
	$spacket->setInt(<xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'});
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="name() = 'string'">
	<xsl:call-template name="procdef" ><xsl:with-param name="deep"><xsl:value-of select="$deepv" /></xsl:with-param></xsl:call-template>
	$spacket->setStr(<xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'});</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="name() = 'double'">
	<xsl:call-template name="procdef" ><xsl:with-param name="deep"><xsl:value-of select="$deepv" /></xsl:with-param></xsl:call-template>
	$spacket->setDbl(<xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'});</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
					<xsl:when test="name() = 'ip_address'">
	<xsl:call-template name="procdef" ><xsl:with-param name="deep"><xsl:value-of select="$deepv" /></xsl:with-param></xsl:call-template>
	$spacket->setIP(<xsl:value-of select="$deepv" />->{'<xsl:value-of select="@name" />'});</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="name() = 'for'">
						<xsl:variable name="numfor" select="count(preceding-sibling::for)" />
						<xsl:variable name="isfunc">
					        <xsl:if test="contains(@count,'(') and contains(@count,')')">1</xsl:if>
					        </xsl:variable>
						<xsl:variable name="isnum">
					        <xsl:if test="number(@count) != NaN">1</xsl:if>
					        </xsl:variable>
	for (my $<xsl:value-of select="@name" /> = <xsl:value-of select="@from" />; $<xsl:value-of select="@name" /> &lt; <xsl:choose><xsl:when test="$isfunc = 1">$self-><xsl:value-of select="@count" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="$isnum = 1"><xsl:value-of select="@count" /></xsl:when><xsl:otherwise>$href->{'<xsl:value-of select="@count" />'}</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>; $<xsl:value-of select="@name" />++) {
		<xsl:call-template name="input" select="." mode="main"><xsl:with-param name="deep"><xsl:value-of select="$deepv" />->{'arr_<xsl:value-of select="$numfor" />'}[$<xsl:value-of select="@name" />]</xsl:with-param></xsl:call-template>
	} 
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="name() = 'if'">
	if (<xsl:value-of select="$deepv" />->{'<xsl:value-of select="@variable" />'} <xsl:value-of select="@condition" /> "<xsl:value-of select="@value" />") {
		<xsl:call-template name="input" select="." mode="main"><xsl:with-param name="deep"><xsl:value-of select="$deepv" /></xsl:with-param></xsl:call-template>
	}
							</xsl:if>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
				</xsl:choose>
		

			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>
	
<xsl:template name="getsetvar"><xsl:param name="string" select="@dst" />->{'<xsl:value-of select="@dst" />'}</xsl:template>

<xsl:template name="getifvar">
  <xsl:param name="string" select="@array_index" />
  <xsl:choose><xsl:when test="$string">
  <xsl:choose>
    <xsl:when test="contains($string, ',')">->[$<xsl:value-of select="substring-before($string, ',')" />]<xsl:call-template name="getvar"><xsl:with-param name="string" select="substring-after($string, ',')" /></xsl:call-template></xsl:when>
 <xsl:otherwise>->[$<xsl:value-of select="$string" />]->{'<xsl:value-of select="@variable" />'}</xsl:otherwise>
  </xsl:choose></xsl:when>
  <xsl:otherwise>->{'<xsl:value-of select="@variable" />'} </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="getvar">
  <xsl:param name="string" select="@array_index" />
  <xsl:param name="notfirst" />

  <xsl:choose><xsl:when test="$string">
  <xsl:choose>
   <xsl:when test="$notfirst">

  <xsl:choose>
    <xsl:when test="contains($string, ',')">->[$<xsl:value-of select="substring-before($string, ',')" />]<xsl:call-template name="getvar"><xsl:with-param name="string" select="substring-after($string, ',')" /><xsl:with-param name="notfirst" /></xsl:call-template></xsl:when>
 <xsl:otherwise>->[$<xsl:value-of select="$string" />]->{'<xsl:value-of select="@name" />'}</xsl:otherwise>
  </xsl:choose>



   </xsl:when><xsl:otherwise>
 
  <xsl:choose>
    <xsl:when test="contains($string, ',')">->{'arr'}[$<xsl:value-of select="substring-before($string, ',')" />]<xsl:call-template name="getvar"><xsl:with-param name="string" select="substring-after($string, ',')" /><xsl:with-param name="notfirst" /></xsl:call-template></xsl:when>
 <xsl:otherwise>->{'arr'}[$<xsl:value-of select="$string" />]->{'<xsl:value-of select="@name" />'}</xsl:otherwise>
  </xsl:choose>
 	 
  </xsl:otherwise></xsl:choose>
 </xsl:when>
  <xsl:otherwise>->{'<xsl:value-of select="@name" />'} </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="output" name="output">

	<xsl:for-each select="*">
		<xsl:choose>
		<xsl:when test="name() = 'integer'">
	$rv<xsl:call-template name="getvar" /> = $spacket->getInt();
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="name() = 'string'">
	$rv<xsl:call-template name="getvar" /> = $spacket->getStr();
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="name() = 'double'">
	$rv<xsl:call-template name="getvar" /> = $spacket->getDbl();
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
					<xsl:when test="name() = 'ip_address'">
	$rv<xsl:call-template name="getvar" /> = $spacket->getIP();
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="name() = 'for'">
						<xsl:variable name="numfor" select="count(preceding-sibling::for)" />
						<xsl:variable name="isfunc">
					        <xsl:if test="contains(@count,'(') and contains(@count,')')">1</xsl:if>
					        </xsl:variable>
						<xsl:variable name="isnum">
					        <xsl:if test="number(@count) != NaN">1</xsl:if>
					        </xsl:variable>
			
	for (my $<xsl:value-of select="@name" /> = <xsl:value-of select="@from" />; $<xsl:value-of select="@name" /> &lt; <xsl:choose><xsl:when test="$isfunc = 1">$self-><xsl:value-of select="@count" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="$isnum = 1"><xsl:value-of select="@count" /></xsl:when><xsl:otherwise>$rv->{'<xsl:value-of select="@count" />'}</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>; $<xsl:value-of select="@name" />++) {
		<xsl:call-template name="output" select="." mode="main"></xsl:call-template>
	} 
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
							<xsl:when test="name() = 'if'">
	if ($rv<xsl:call-template name="getifvar" /> 	<xsl:value-of select="@condition" /> <xsl:choose><xsl:when test="@value = -1" > "4294967295"</xsl:when><xsl:otherwise> "<xsl:value-of select="@value" />"</xsl:otherwise></xsl:choose>) {
		<xsl:call-template name="output" select="." mode="main"></xsl:call-template>
	}
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
								<xsl:when test="name() = 'error'">
		$self->{'obj'}->{'error'} = "<xsl:value-of select="@comment" />";
		return -1;				
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="name() = 'set'">
		$rv<xsl:call-template name="getsetvar" /> = <xsl:choose><xsl:when test="@src_index">${$self->get_var("<xsl:value-of select="@src" />")}[$<xsl:value-of select="@src_index" />]->{'<xsl:value-of select="@src" />'}</xsl:when><xsl:otherwise>$self->get_var("<xsl:value-of select="@src" />")</xsl:otherwise></xsl:choose>;
									</xsl:if>
								</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
				</xsl:choose>
		

			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
