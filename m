Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O0hX0C089824 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:43:34 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D68913E9DCC
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 17:44:16 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id aKIL7wZHpMo0Gr7c for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 17:44:16 -0700 (PDT)
Received: from imp09 ([10.20.200.9]) by mta11.charter.net
	(InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
	id <20090724004416.KTTV22327.mta11.charter.net@imp09>
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:44:16 -0400
Received: from c400 (dhcp-yelw-03-11.internal.sessys.com [192.168.3.11])
	(authenticated bits=0) (authenticated user=elbles)
	by mail.sessys.com (8.13.7/8.13.7-SES__MASTER) with ESMTP id
	n6O0iD4L014638
	(version=TLSv1/SSLv3 cipher=DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:44:14 -0400
From: "Sean Elble" <elbles@sessys.com>
Subject: UPDATE: Using xfsdump On Linux With IRIX Version 1 FS
Date: Thu, 23 Jul 2009 20:44:13 -0400
Message-ID: <009601ca0bf7$de568440$9b038cc0$@com>
MIME-Version: 1.0
Content-Language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1579662233030046501=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============1579662233030046501==
Content-Language: en-us
Content-Type: multipart/signed;
	micalg=SHA1;
	protocol="application/x-pkcs7-signature";
	boundary="----=_NextPart_000_0091_01CA0BD6.55ACDF20"

This is a multi-part message in MIME format.

------=_NextPart_000_0091_01CA0BD6.55ACDF20
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

My apologies for my last e-mail, as I apparently missed this crucial line in
the xfsdump(8) man page:

"The filesystem, filesystem, can be specified either as a mount point or as
a special device file (for example, /dev/dsk/dks0d1s0). The filesystem must
be mounted to be dumped."

Oh well.  If anyone has any other thoughts on how to reset the root password
on an IRIX box with a version 1 XFS file system without IRIX CDs, that would
be appreciated, heh.

-- 
+-------------------------------------------------
|  Sean Elble      
|  Virginia Tech, Class of 2009
|  E-Mail:   elbles@sessys.com
|  Web:      http://www.sessys.com/~elbles/
|  Cell:     860.946.9477
+-------------------------------------------------



------=_NextPart_000_0091_01CA0BD6.55ACDF20
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJVDCCAtww
ggJFoAMCAQICEC9/k0eNz8FH+XIKgerFfGMwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDExNjAzMDY1N1oXDTEwMDExNjAzMDY1
N1owQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4GCSqGSIb3DQEJARYRZWxi
bGVzQHNlc3N5cy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCfR8VzMbvmwy4+
ohpVDe9tw36kwluDuZV/xQAYXs7o5tShCh9Vl1493hbeLIbbGIayxN1FNqfuzm47/HV0sVE6gWTV
ltrMLfazyIcP+53JB95omy/TZ7TwmUK3nhqPAuCVlLEAlJgpoKYBfmpSK6Y4SRGDzqx/pzRHLkBt
8FyKN+DQ8R7im0pXqyAX75UKjWjMHFLE39u0b0tHQbnAcnIC4Jz5uKIa/7v9jq+KEd0xedJVouba
bPrETqgRXCX624tc9fpRQp4RRO2IO6rI5N/s8VqEYg95bOQOR1Ix/3wvHHNWqxrpqTelWARARl4+
GK0sVMM/HlGVgRR9Y8VYEv6rAgMBAAGjLjAsMBwGA1UdEQQVMBOBEWVsYmxlc0BzZXNzeXMuY29t
MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAG4ldJjGC282reNDBG4eahTikx/rXLIpb
yhIQpo8FvMXU+DAMEVqsApqu5spA4hQkZwa8Bs9u8IJcv6uftCxF+78svFUmmxmKCeqen7Vd3mdz
/bSCSiJj8BeUV/hueaT2XAoX0BUeVbY9ZpSou934vsM3Lo1lDOCjdNJxTeO38RYwggMtMIIClqAD
AgECAgEAMA0GCSqGSIb3DQEBBAUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBD
YXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYD
VQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVy
c29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0
ZS5jb20wHhcNOTYwMTAxMDAwMDAwWhcNMjAxMjMxMjM1OTU5WjCB0TELMAkGA1UEBhMCWkExFTAT
BgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUg
Q29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIG
A1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25h
bC1mcmVlbWFpbEB0aGF3dGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUadfUsJRk
W3HpR9gMUbbqcpGwhF59LQ2PexLfhSV1KHQ6QixjJ5+Ve0vvfhmHHYbqo925zpZkGsIUbkSsfOaP
6E0PcR9AOKYAo4d49vmUhl6t6sBeduvZFKNdbnp8DKVLVX8GGSl/npom1Wq7OCQIapjHsdqjmJH9
edvlWsQcuQIDAQABoxMwETAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBBAUAA4GBAMfskn5O
+PWWpWdiKqTwTRFg0G+NYFhhrCa7UjVcCM8w+6hKloofYkIjjBcP9LpknBesRynfnZhe0mxgcVyi
rNx54+duAEcftQ0o6AKd5Jr9E/Sm2Xyx+NxfIyYJkYBz0BQb3kOpgyXy5pwvFcr+pquKB3WLDN1R
hGvk+NHOd6KBMIIDPzCCAqigAwIBAgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkEx
FTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3
dGUgQ29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEk
MCIGA1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJz
b25hbC1mcmVlbWFpbEB0aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVow
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEB
AQUAA4GNADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU
5VAKMNcCY1osiRVwjt3J8CuFWqo/cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTX
p6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8C
AQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFs
RnJlZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2
YXRlTGFiZWwyLTEzODANBgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aU
nX9MIbj4Nh+qLZ82L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5
jowgT2Vfldr394fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCA3kwggN1AgEB
MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4x
LDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAvf5NHjc/BR/ly
CoHqxXxjMAkGBSsOAwIaBQCgggHYMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTA5MDcyNDAwNDQxMlowIwYJKoZIhvcNAQkEMRYEFLEOAI2ejrmEblEgodT1D5Zgx6Bg
MGcGCSqGSIb3DQEJDzFaMFgwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMAcGBSsOAwIaMAoGCCqGSIb3DQIFMIGFBgkrBgEE
AYI3EAQxeDB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5
KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQL3+T
R43PwUf5cgqB6sV8YzCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwg
RnJlZW1haWwgSXNzdWluZyBDQQIQL3+TR43PwUf5cgqB6sV8YzANBgkqhkiG9w0BAQEFAASCAQAv
nrd+ipooqMJ6aoohbJKs0mll+rE9SpS6tNrGZcaPgVuXckHz0q2hMHedIigrwgl/FdC9YqlTxSt5
v0HU0OuP+V+uuNzgDFu/hc8KGWVJv8uyqBg41U9+rqyKFmWy7rIF0TCH/7kaY6e9s/oum2afC5yD
HymRdwNoVAAdiwm9RPjgteWaoW9qgyZVEVydaKwSaqXmENO6FXCngBOx42NuR22BWuzcPxHry+vK
2aD3Pf1hD/QR24WP0NFWjvo3gMwX0B4P6Ii3ixBmqz+5O6N8u+bh2UVR94oFYcU293hov7kivFcD
JDUKaI8h9uZMuNcE/avTf4wkwY6XLEuWLQUwAAAAAAAA

------=_NextPart_000_0091_01CA0BD6.55ACDF20--


--===============1579662233030046501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1579662233030046501==--
