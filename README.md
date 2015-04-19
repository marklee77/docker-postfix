use phusion?

exactly which packages to install?

modify master.cf using sed instead of postconf?

step 1 is to make it easy to send mail

step 2 is to add imap

step 3 is to think about scalability...

how to set milters for submission?

milters (in this order):
    opendmarc
    phwhois
    clamav
    spamassassin
    dspam
