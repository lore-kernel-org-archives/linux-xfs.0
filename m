Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Aug 2006 12:41:18 -0700 (PDT)
Received: from uwast.astro.wisc.edu (uwast.astro.wisc.edu [144.92.110.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7PJf7DW025851
	for <linux-xfs@oss.sgi.com>; Fri, 25 Aug 2006 12:41:08 -0700
Received: from [192.168.1.101] (ppp-70-226-167-16.dsl.mdsnwi.ameritech.net [70.226.167.16])
	(authenticated bits=0)
	by uwast.astro.wisc.edu (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id k7PIfgls007290
	for <linux-xfs@oss.sgi.com>; Fri, 25 Aug 2006 13:41:45 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
Message-Id: <9754D30D-C670-4D71-AB60-BD6152120B63@astro.wisc.edu>
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-10--17039959; protocol="application/pkcs7-signature"
References: <9E7A5312-6215-4BF8-9FBC-1F688AC366BB@astro.wisc.edu>
From: Stephan Jansen <jansen@astro.wisc.edu>
Subject: Files greater than 2TB on 32 bit SLES9 SP3?
Date: Fri, 25 Aug 2006 13:41:42 -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

--Apple-Mail-10--17039959
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed


Hi,

Can we create file systems of 3TB and individual files larger than
2TB on a 32 bit version of SLES9 SP3 using XFS?  If I read the XFS
project page correctly then this should work but I thought I'd ask
the list before I try it.  Thanks.


--

----- Stephan


--Apple-Mail-10--17039959
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEH
AQAAoIIGLzCCAvQwggJdoAMCAQICAkRNMA0GCSqGSIb3DQEBBQUAMFMxCzAJ
BgNVBAYTAlVTMRwwGgYDVQQKExNFcXVpZmF4IFNlY3VyZSBJbmMuMSYwJAYD
VQQDEx1FcXVpZmF4IFNlY3VyZSBlQnVzaW5lc3MgQ0EtMTAeFw0wNTA4Mjkx
NjA3MjBaFw0xNTA4MjkxNjA3MjBaMIGJMQswCQYDVQQGEwJVUzErMCkGA1UE
ChMiRGl2aXNpb24gb2YgSW5mb3JtYXRpb24gVGVjaG5vbG9neTEjMCEGA1UE
CxMaRmFjdWx0eSAtIFN0YWZmIC0gU3R1ZGVudHMxKDAmBgNVBAMTH1VuaXZl
cnNpdHkgb2YgV2lzY29uc2luLU1hZGlzb24wgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAOhIUdwld8sfAAlrdOv5Tt8PTX1Wku/ItsIjHrkus1MbKoul
SXxSsSUPAPYzgT8HfhuRY+tHHzohFSu3xJWgx0wk8q2pqwo4KZ2evy7GMDFx
THyXSYa/1m0Wsg5c11u8J6/tR8yqu7RWIJPr+edlPjx8r/cYP7AK5nA7msMF
FZqDAgMBAAGjgZ8wgZwwDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBQcnlJS
GwRiRyxrLAG4afGpNywjJDAfBgNVHSMEGDAWgBRKeDJSEdtZFjZe38EUNkBq
R3xMoTAPBgNVHRMBAf8EBTADAQH/MDkGA1UdHwQyMDAwLqAsoCqGKGh0dHA6
Ly9jcmwuZ2VvdHJ1c3QuY29tL2NybHMvZWJpemNhMS5jcmwwDQYJKoZIhvcN
AQEFBQADgYEAJfFEWDN3f+cS1o3XqrcgmDdr5h3e37WxerB/YxVfHpsr5UzT
GVBwR09zyRA+AtmBrNBE07HcLSsri/x9o1qJPwtko8GB+ScW9lTvoSoWKf93
fkeymKj4T7X2rFV+umJTSmgs850RTh+oRx0eVGHfc1zHRNjpUiPqZRoaYqjF
Z5AwggMzMIICnKADAgECAgIAqzANBgkqhkiG9w0BAQUFADCBiTELMAkGA1UE
BhMCVVMxKzApBgNVBAoTIkRpdmlzaW9uIG9mIEluZm9ybWF0aW9uIFRlY2hu
b2xvZ3kxIzAhBgNVBAsTGkZhY3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMSgw
JgYDVQQDEx9Vbml2ZXJzaXR5IG9mIFdpc2NvbnNpbi1NYWRpc29uMB4XDTA1
MTEwODE5NDg0NloXDTA2MTEwODE5NDg0NlowgcExCzAJBgNVBAYTAlVTMRIw
EAYDVQQIEwlXaXNjb25zaW4xEDAOBgNVBAcTB01hZGlzb24xKDAmBgNVBAoT
H1VuaXZlcnNpdHkgb2YgV2lzY29uc2luLU1hZGlzb24xIzAhBgNVBAsTGkZh
Y3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMRcwFQYDVQQDEw5TdGVwaGVuIEph
bnNlbjEkMCIGCSqGSIb3DQEJARYVamFuc2VuQGFzdHJvLndpc2MuZWR1MIGf
MA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYmSqLM5WAgcBhd+EtQ3lxnq2H
u6TA+EN1lzR/ZKyEjg/cFhajrs+Py5qrADFp62Chsq1BcqI8l3j3oQMiQgni
AGxVrBkg/Al5nlUuzm3G/zpgoxbOXdBPv1xv7b52ylcKkaW4byOswQdZqSLt
H7aNPHdyDLFKEG9nw4TuGPm9sQIDAQABo3AwbjAOBgNVHQ8BAf8EBAMCBeAw
OwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybC5nZW90cnVzdC5jb20vY3Js
cy93aXNjb25zaW4uY3JsMB8GA1UdIwQYMBaAFByeUlIbBGJHLGssAbhp8ak3
LCMkMA0GCSqGSIb3DQEBBQUAA4GBAHslg5nIvKIHNbz6jAwLHx4JK++gdHUA
GJxm8NCog0S58/nJXNJZpiCV3YY1feC3s+8eM0LusZXJJ5O8SgRBLmBP1TMp
pIbX0WSZz40xn+IqBbSDboK2s6694y0aS8f1O/1I0+r6AEXhnBtPxK8U9UYN
quW4bAAme3t0sHAoaFANMYIC4jCCAt4CAQEwgZAwgYkxCzAJBgNVBAYTAlVT
MSswKQYDVQQKEyJEaXZpc2lvbiBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5
MSMwIQYDVQQLExpGYWN1bHR5IC0gU3RhZmYgLSBTdHVkZW50czEoMCYGA1UE
AxMfVW5pdmVyc2l0eSBvZiBXaXNjb25zaW4tTWFkaXNvbgICAKswCQYFKw4D
AhoFAKCCAacwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMDYwODI1MTg0MTQzWjAjBgkqhkiG9w0BCQQxFgQUKcxY7bHMQtlN
7hRVRQbr1b+d0wkwgaEGCSsGAQQBgjcQBDGBkzCBkDCBiTELMAkGA1UEBhMC
VVMxKzApBgNVBAoTIkRpdmlzaW9uIG9mIEluZm9ybWF0aW9uIFRlY2hub2xv
Z3kxIzAhBgNVBAsTGkZhY3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMSgwJgYD
VQQDEx9Vbml2ZXJzaXR5IG9mIFdpc2NvbnNpbi1NYWRpc29uAgIAqzCBowYL
KoZIhvcNAQkQAgsxgZOggZAwgYkxCzAJBgNVBAYTAlVTMSswKQYDVQQKEyJE
aXZpc2lvbiBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5MSMwIQYDVQQLExpG
YWN1bHR5IC0gU3RhZmYgLSBTdHVkZW50czEoMCYGA1UEAxMfVW5pdmVyc2l0
eSBvZiBXaXNjb25zaW4tTWFkaXNvbgICAKswDQYJKoZIhvcNAQEBBQAEgYA9
vJJwS+52j5Bj34eRHyLGhHlhCHrKyd9yZ/nH1tbWCXOZ0/itGSOUQqZIvdyq
4mN2EKx2K13iU9Vy6VaBdtUyfCPoGkKwHL8xc7gA8dz+eVr+G5/8jkHt4+OC
f8hu9MLJymWZ7WvJimEs95LB0daNM+OPsyNklJYpo8YumwVIYAAAAAAAAA==

--Apple-Mail-10--17039959--
