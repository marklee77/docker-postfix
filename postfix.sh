#!/bin/bash
: ${postconf_myhostname:='localhost'}
: ${postconf_mydestination:='localhost, localhost.localdomain, localhost.\\$mydomain, \\$myhostname, \\$myhostname.localdomain, \\$myhostname.\\$mydomain, localdomain, \\$mydomain'}
: ${postconf_mynetworks:="$(postconf -h mynetworks) $(ip route show | perl -l40 -ne 'print $1 if /^((?:\d{1,3}\.){3}\d{1,3}\/\d{1,2}).*?\sscope\s+link\s/')"}
: ${postconf_smtpd_banner:='\\$myhostname ESMTP'}
: ${postconf_smtpd_helo_required:='yes'}
: ${postconf_smtpd_tls_auth_only:='yes'}
: ${postconf_disable_vrfy_command:='yes'}
: ${postconf_strict_rfc821_envelopes:='yes'}
: ${postconf_postscreen_greet_action:='enforce'}
: ${postconf_postscreen_dnsbl_action:='enforce'}
: ${postconf_postscreen_dnsbl_sites:='zen.spamhaus.org, psbl.surriel.com, dnsbl.sorbs.net'}
: ${postconf_smtpd_recipient_restrictions:='
    permit_mynetworks, 
    reject_unauth_pipelining, 
    reject_unknown_client_hostname, 
    reject_invalid_helo_hostname, 
    reject_non_fqdn_helo_hostname, 
    reject_non_fqdn_sender, 
    reject_unknown_sender_domain, 
    reject_non_fqdn_recipient, 
    reject_unknown_recipient_domain, 
    reject_unlisted_recipient, 
    reject_unauth_destination, 
    reject_rbl_client zen.spamhous.org, 
    reject_rbl_client psbl_surriel.com, 
    reject_rbl_client dnsbl.sorbs.net, 
    reject_rhsbl_client rhsbl.sorbs.net, 
    reject_rhsbl_sender rhsbl.sorbs.net, 
    check_policy_service unix:private/policy-spf, 
    permit'}
: ${postconf_policy-spf_time_limit:='3600s'}

export postconf_myhostname postconf_mynetworks postconf_smtpd_banner postconf_smtpd_helo_required postconf_disable_vrfy_command postconf_strict_rfc821_envelopes postconf_postscreen_greet_action postconf_postscreen_dnsbl_action postconf_postscreen_dnsbl_sites postconf_smtpd_recipient_restrictions

# need to add container hostname to get local delivery
export postconf_mydestination="$postconf_mydestination, $HOSTNAME"

# The following are recommended by bettercrypto.org, override at your peril:
: ${postconf_smtpd_tls_eecdh_grade:='ultra'}
: ${postconf_smtpd_tls_mandatory_ciphers:='high'}
: ${postconf_smtpd_tls_mandatory_protocols:='!SSLv2, !SSLv3'}
: ${postconf_tls_high_cipherlist:='EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!ECDSA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA'}
: ${postconf_tls_ssl_options:='NO_COMPRESSION'}

export postconf_smtpd_tls_eecdh_grade postconf_smtpd_tls_mandatory_ciphers postconf_smtpd_tls_mandatory_protocols postconf_tls_high_cipherlist postconf_tls_ssl_options 

env | grep ^postconf_ | while IFS="=" read key value; do
    postconf -e ${key#postconf_}="$(eval "echo $value")"
done

/etc/init.d/postfix start
