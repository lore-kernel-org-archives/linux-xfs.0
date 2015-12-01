Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C5A37F53
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 09:16:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97FC4AC004
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 07:16:17 -0800 (PST)
Received: from smtp1.mail.krollworldwide.com (smtp1.mail.krollworldwide.com
	[208.71.237.35]) by cuda.sgi.com with ESMTP id jbbJ5JLkS5abkDm7
	(version=TLSv1 cipher=DHE-RSA-CAMELLIA256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 07:16:13 -0800 (PST)
From: "Epp, Mike" <MEpp@KrollOntrack.com>
Subject: Question on how to submit changed code
Date: Tue, 1 Dec 2015 15:16:11 +0000
Message-ID: <105716A9A63E8A4C9CB26A0F29E203DCF40BE069@usbpx2pmxmbx12>
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
Content-Type: multipart/mixed; boundary="===============7460478712308284972=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7460478712308284972==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_105716A9A63E8A4C9CB26A0F29E203DCF40BE069usbpx2pmxmbx12_"

--_000_105716A9A63E8A4C9CB26A0F29E203DCF40BE069usbpx2pmxmbx12_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have changed code in libxfs and repair projects for xfsprogs.  I don't vi=
ew the changes as desired for ongoing deployment, as they allowed scanning =
of active volumes and bring the chance of false errors.  To stay compliant =
with GNU GPL though we must publish the code.  What are the steps I need to=
 follow to publish the changes?  Do I need to publish just the source files=
 I changed, the entire projects I changes, or all of xfsprogs?

Mike Epp, Senior Software Engineer
Kroll Ontrack |  9023 Columbine Road, Eden Prairie, MN 55347
mepp@krollontrack.com<mailto:mepp@krollontrack.com>
www.krollontrack.com<http://www.krollontrack.com/ohttp:/www.krollontrack.co=
m/>
This communication contains information that is confidential, proprietary i=
n nature, and may also be attorney-client privileged and/or work product pr=
ivileged. It is for the exclusive use of the intended recipient(s). If you =
are not the intended recipient(s) or the person responsible for delivering =
it to the intended recipient(s), please note that any form of dissemination=
, distribution or copying of this communication is strictly prohibited and =
may be unlawful. If you have received this communication in error, please i=
mmediately notify the sender and delete the original communication. Thank y=
ou for your cooperation.
Please be advised that neither Kroll, its affiliates, its employees or agen=
ts accept liability for any errors, omissions or damages caused by delays o=
f receipt or by any virus infection in this message or its attachments, or =
which may otherwise arise as a result of this e-mail transmission.


--_000_105716A9A63E8A4C9CB26A0F29E203DCF40BE069usbpx2pmxmbx12_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">I have changed code in libxfs and repair projects fo=
r xfsprogs.&nbsp; I don&#8217;t view the changes as desired for ongoing dep=
loyment, as they allowed scanning of active volumes and bring the chance of=
 false errors.&nbsp; To stay compliant with GNU GPL
 though we must publish the code.&nbsp; What are the steps I need to follow=
 to publish the changes?&nbsp; Do I need to publish just the source files I=
 changed, the entire projects I changes, or all of xfsprogs?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b><span style=3D"font-size:10.0pt;font-family:&quot=
;Tahoma&quot;,&quot;sans-serif&quot;;color:black">Mike Epp</span></b><span =
style=3D"font-size:10.0pt;font-family:&quot;Tahoma&quot;,&quot;sans-serif&q=
uot;;color:black">, Senior Software Engineer</span><span style=3D"font-size=
:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;"><o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Ta=
homa&quot;,&quot;sans-serif&quot;;color:gray">Kroll Ontrack |&nbsp;&nbsp;90=
23 Columbine Road, Eden Prairie, MN 55347<br>
</span><a href=3D"mailto:mepp@krollontrack.com"><span style=3D"font-size:10=
.0pt;font-family:&quot;Tahoma&quot;,&quot;sans-serif&quot;;color:blue">mepp=
@krollontrack.com</span></a><span style=3D"font-size:10.0pt;font-family:&qu=
ot;Tahoma&quot;,&quot;sans-serif&quot;;color:gray">
<br>
</span><a href=3D"http://www.krollontrack.com/ohttp:/www.krollontrack.com/"=
 title=3D"blocked::http://www.krollontrack.com/ohttp:/www.krollontrack.com/=
"><span style=3D"font-size:10.0pt;font-family:&quot;Tahoma&quot;,&quot;sans=
-serif&quot;;color:gray">www.krollontrack.com</span></a><span style=3D"font=
-size:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;"><o:=
p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;mso-margin-bottom-a=
lt:auto"><span style=3D"font-size:7.5pt;font-family:&quot;Times New Roman&q=
uot;,&quot;serif&quot;;color:gray">This communication contains information =
that is confidential, proprietary in nature, and may also
 be attorney-client privileged and/or work product privileged. It is for th=
e exclusive use of the intended recipient(s). If you are not the intended r=
ecipient(s) or the person responsible for delivering it to the intended rec=
ipient(s), please note that any
 form of dissemination, distribution or copying of this communication is st=
rictly prohibited and may be unlawful. If you have received this communicat=
ion in error, please immediately notify the sender and delete the original =
communication. Thank you for your
 cooperation.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:7.5pt;font-family:&quot;Tim=
es New Roman&quot;,&quot;serif&quot;;color:gray">Please be advised that nei=
ther Kroll, its affiliates, its employees or agents accept liability for an=
y errors, omissions or damages caused by delays of receipt
 or by any virus infection in this message or its attachments, or which may=
 otherwise arise as a result of this e-mail transmission.</span><o:p></o:p>=
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_105716A9A63E8A4C9CB26A0F29E203DCF40BE069usbpx2pmxmbx12_--


--===============7460478712308284972==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7460478712308284972==--
