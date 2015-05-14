Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 56E217F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 23:17:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 48C58304032
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 21:17:22 -0700 (PDT)
Received: from mx0a-00153101.pphosted.com (mx0a-00153101.pphosted.com
	[67.231.145.89]) by cuda.sgi.com with ESMTP id JBXoitGACknMx0wk
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 May 2015 21:17:20 -0700 (PDT)
Received: from pps.filterd (m0000823 [127.0.0.1])
	by mx0a-00153101.pphosted.com (8.14.5/8.14.5) with SMTP id
	t4E4DwMg025966 for <xfs@oss.sgi.com>; Wed, 13 May 2015 22:17:19 -0600
Received: from srvmsxedgeden1.ad.twtelecom.com
	(168-215-22-30.static.twtelecom.net [168.215.22.30])
	by mx0a-00153101.pphosted.com with ESMTP id 1uc028axha-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 22:17:19 -0600
From: "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Subject: xfs_repair fails
Date: Thu, 14 May 2015 04:17:17 +0000
Message-ID: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3411937559943990785=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3411937559943990785==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D42CEF46A796364580AFE375880EF73F01AD63BE36SRVMSXMBDEN2a_"

--_000_D42CEF46A796364580AFE375880EF73F01AD63BE36SRVMSXMBDEN2a_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have an XFS filesystem built on a 24T RAID6 Array under Debian Jessie Lin=
ux.  The kernel is 3.16-2-amd64, and the xfs_repair version is 3.2.1.  The =
file system has some inconsistencies, but every time I try to run xfs_repai=
r, it segfaults.  What should I do?



-------------

The content contained in this electronic message is not intended to constit=
ute formation of a contract binding Level3. Level3 will be contractually bo=
und only upon execution, by an authorized officer, of a contract including =
agreed terms and conditions or by express application of its tariffs. This =
message is intended only for the use of the individual or entity to which i=
t is addressed. If the reader of this message is not the intended recipient=
, or the employee or agent responsible for delivering the message to the in=
tended recipient, you are hereby notified that any dissemination, distribut=
ion or copying of this message is strictly prohibited. If you have received=
 this communication in error, please notify us immediately by replying to t=
he sender of this E-Mail or by telephone.

--_000_D42CEF46A796364580AFE375880EF73F01AD63BE36SRVMSXMBDEN2a_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">
<div style=3D"text-indent:36pt;">I have an XFS filesystem built on a 24T RA=
ID6 Array under Debian Jessie Linux.&nbsp; The kernel is 3.16-2-amd64, and =
the xfs_repair version is 3.2.1.&nbsp; The file system has some inconsisten=
cies, but every time I try to run xfs_repair,
it segfaults.&nbsp; What should I do?</div>
<div>&nbsp;</div>
<div><font face=3D"Arial" size=3D"2"><span style=3D"font-size:9pt;">&nbsp;<=
/span></font></div>
<div style=3D"margin-top:14pt;"><font face=3D"Arial" size=3D"2"><span style=
=3D"font-size:9pt;">------------- </span></font></div>
<div style=3D"margin-top:14pt;"><font face=3D"Arial" size=3D"2"><span style=
=3D"font-size:9pt;">&nbsp;</span></font></div>
<div style=3D"margin-top:14pt;"><font face=3D"Arial" size=3D"2"><span style=
=3D"font-size:9pt;">The content contained in this electronic message is not=
 intended to constitute formation of a contract binding <b>Level3</b>. <b>L=
evel3</b> will be contractually bound only
upon execution, by an authorized officer, of a contract including agreed te=
rms and conditions or by express application of its tariffs. This message i=
s intended only for the use of the individual or entity to which it is addr=
essed. If the reader of this message
is not the intended recipient, or the employee or agent responsible for del=
ivering the message to the intended recipient, you are hereby notified that=
 any dissemination, distribution or copying of this message is strictly pro=
hibited. If you have received this
communication in error, please notify us immediately by replying to the sen=
der of this E-Mail or by telephone.<br>

</span></font></div>
</span></font>
</body>
</html>

--_000_D42CEF46A796364580AFE375880EF73F01AD63BE36SRVMSXMBDEN2a_--


--===============3411937559943990785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3411937559943990785==--
