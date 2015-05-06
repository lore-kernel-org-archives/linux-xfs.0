Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D97927F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 10:17:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF31B304039
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 08:17:08 -0700 (PDT)
Received: from smtp4out.l-3com.com (smtp4out.l-3com.com [128.170.207.112]) by
	cuda.sgi.com with ESMTP id PQYpCalukxf8OB10 for
	<xfs@oss.sgi.com>; Wed, 06 May 2015 08:17:05 -0700 (PDT)
From: "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Subject: SGI Version 1 XFS on Linux
Date: Wed, 6 May 2015 15:12:59 +0000
Message-ID: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
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
Content-Type: multipart/mixed; boundary="===============6977555138827817920=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6977555138827817920==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_2994A55DE0FBBE41B8FE47F9885D74221BC0569CARLEXCHMBX02lst_"

--_000_2994A55DE0FBBE41B8FE47F9885D74221BC0569CARLEXCHMBX02lst_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

We have several older SGI hard drives we are trying to recover data from. H=
owever, since these drives came from an SGI Onyx running IRIX 6.2, it uses =
the older version 1 XFS file system. I can see the SCSI drive on my Linux b=
ox (CentOS 5.11) and I know data is on the drive, I can list out some of th=
e info using dd, cpio or strings, but cannot copy the data off of it. I hav=
e tried using xfs_copy to a version 2 XFS partition, but it just converts t=
he target partition to version 1, which I cannot mount. I have also looked =
at xfs_dump/restore, but those require mounted filesystems.

Is there any script or program or option I can use to copy the data off of =
the un-mounted SGI XFS partition. I'm guessing some combination of the cpio=
 and dd, but I have not figured out the right combination yet.

Thanks,
Ed



--_000_2994A55DE0FBBE41B8FE47F9885D74221BC0569CARLEXCHMBX02lst_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
	{mso-style-type:export-only;}
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
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We have several older SGI hard drives we are trying =
to recover data from. However, since these drives came from an SGI Onyx run=
ning IRIX 6.2, it uses the older version 1 XFS file system. I can see the S=
CSI drive on my Linux box (CentOS
 5.11) and I know data is on the drive, I can list out some of the info usi=
ng dd, cpio or strings, but cannot copy the data off of it. I have tried us=
ing xfs_copy to a version 2 XFS partition, but it just converts the target =
partition to version 1, which I
 cannot mount. I have also looked at xfs_dump/restore, but those require mo=
unted filesystems.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is there any script or program or option I can use t=
o copy the data off of the un-mounted SGI XFS partition. I&#8217;m guessing=
 some combination of the cpio and dd, but I have not figured out the right =
combination yet.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Ed<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_2994A55DE0FBBE41B8FE47F9885D74221BC0569CARLEXCHMBX02lst_--


--===============6977555138827817920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6977555138827817920==--
