Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0THGVq6220397 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 11:16:35 -0600
Received: from smtp1.abanet.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E9A2CA0ED
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:15:49 -0800 (PST)
Received: from smtp1.abanet.org (smtp1.abanet.org [208.49.131.60]) by
	cuda.sgi.com with ESMTP id S3VszsHnoa5E4Lzc for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:15:49 -0800 (PST)
Received: from CHG-EMB-01.aba.ad.abanet.org (localhost [127.0.0.1])
	by smtp1.abanet.org  with ESMTP id n0TFoRFO021582
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:50:28 -0600 (CST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: XFS_kupcRep: XFS_bufFind failed 0
Date: Thu, 29 Jan 2009 09:50:56 -0600
Message-ID: <3FDD97ECDAEB29439D3A8B494349EB490B9FA3F1@CHG-EMB-01.aba.ad.abanet.org>
From: "Carmichael, Harry" <CarmichH@staff.abanet.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4586381303170109565=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============4586381303170109565==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C98229.5FC95DE3"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C98229.5FC95DE3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

We are getting the following errors on our TeamStie system, which runs
XFS.

Running on Solaris 8 (117350-38) on a 280R ( sun4u, sparc
SUNW,Sun-Fire-280R ).

=20

Jan 28 15:55:14 tsprod wfs: [ID 701730 kern.notice] 1233179714 - 33645:

Jan 28 15:55:14 tsprod wfs: [ID 209484 kern.notice] Interwoven TeamSite
server is not responding

Jan 28 15:57:35 tsprod wfs: [ID 701730 kern.notice] 1233179855 - 883178:

Jan 28 15:57:35 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:
XFS_bufFind failed 0

Jan 28 15:57:35 tsprod wfs: [ID 701730 kern.notice] 1233179855 - 884907:

Jan 28 15:57:35 tsprod wfs: [ID 497422 kern.notice] Interwoven TeamSite
server is ok

Jan 28 15:57:36 tsprod wfs: [ID 701730 kern.notice] 1233179856 - 29231:

Jan 28 15:57:36 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:
XFS_bufFind failed 0

Jan 28 16:08:49 tsprod wfs: [ID 701730 kern.notice] 1233180529 - 659814:

Jan 28 16:08:49 tsprod wfs: [ID 209484 kern.notice] Interwoven TeamSite
server is not responding

Jan 28 16:09:20 tsprod wfs: [ID 701730 kern.notice] 1233180560 - 337435:

Jan 28 16:09:20 tsprod wfs: [ID 497422 kern.notice] Interwoven TeamSite
server is ok

Jan 28 16:09:29 tsprod wfs: [ID 701730 kern.notice] 1233180569 - 952754:

Jan 28 16:09:29 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:
XFS_bufFind failed 0

=20

Any ideas ?=20

=20


------_=_NextPart_001_01C98229.5FC95DE3
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:#606420;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3D"#606420">

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>We are getting the following errors on our TeamStie =
system,
which runs XFS.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Running on Solaris 8 (117350-38) on a 280R ( sun4u, =
sparc
SUNW,Sun-Fire-280R ).<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:55:14 tsprod wfs: [ID 701730 =
kern.notice]
1233179714 - 33645:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:55:14 tsprod wfs: [ID 209484 =
kern.notice]
Interwoven TeamSite server is not =
responding<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:35 tsprod wfs: [ID 701730 =
kern.notice]
1233179855 - 883178:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:35 tsprod wfs: [ID 654549 =
kern.notice]
XFS_kupcRep: XFS_bufFind failed 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:35 tsprod wfs: [ID 701730 =
kern.notice]
1233179855 - 884907:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:35 tsprod wfs: [ID 497422 =
kern.notice]
Interwoven TeamSite server is ok<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:36 tsprod wfs: [ID 701730 =
kern.notice]
1233179856 - 29231:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 15:57:36 tsprod wfs: [ID 654549 =
kern.notice]
XFS_kupcRep: XFS_bufFind failed 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:08:49 tsprod wfs: [ID 701730 =
kern.notice]
1233180529 - 659814:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:08:49 tsprod wfs: [ID 209484 =
kern.notice]
Interwoven TeamSite server is not =
responding<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:09:20 tsprod wfs: [ID 701730 =
kern.notice]
1233180560 - 337435:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:09:20 tsprod wfs: [ID 497422 =
kern.notice]
Interwoven TeamSite server is ok<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:09:29 tsprod wfs: [ID 701730 =
kern.notice]
1233180569 - 952754:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Jan 28 16:09:29 tsprod wfs: [ID 654549 =
kern.notice]
XFS_kupcRep: XFS_bufFind failed 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Any ideas ? <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C98229.5FC95DE3--


--===============4586381303170109565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4586381303170109565==--
