
XSLTPROC=/usr/bin/xsltproc
XML=/netup/utm5/xml/api.xml
XSLT=./gen.xsl
ARGS=--nonet --nomkdir --novalid
MOD=./URFA/Client.pm

do_it_please: $(XSLT)
	@[ -e "$(XSLTPROC)" ] || (echo "Can't find $(XSLTPROC)" && exit 1)
	@[ -f "$(XML)" ] || (echo "Can't find $(XML)" && exit 1)
	$(XSLTPROC) -o $(MOD) $(ARGS) $(XSLT) $(XML)
