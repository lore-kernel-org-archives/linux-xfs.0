Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B25F7F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 03:53:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B92CAC002
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 01:53:14 -0700 (PDT)
Received: from DUB004-OMC4S7.hotmail.com (dub004-omc4s7.hotmail.com
	[157.55.2.82]) by cuda.sgi.com with ESMTP id 1ZJn1MC6EZApdS4K
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Jul 2014 01:53:10 -0700 (PDT)
Message-ID: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
From: "Frank ." <frank_1005@msn.com>
Subject: Delaylog information enquiry
Date: Tue, 29 Jul 2014 10:53:09 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5355556345169456692=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5355556345169456692==
Content-Type: multipart/alternative;
	boundary="_9cc6956f-f6c3-4c31-94ca-98ec519df573_"

--_9cc6956f-f6c3-4c31-94ca-98ec519df573_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello.=20

I just wanted to have more information about the delaylog feature.=20
>From what I understood it seems to be a common feature from different FS. I=
t's supposed to retain information such as metadata for a time ( how much ?=
). Unfortunately=2C I could not find further information about journaling l=
og section in the XFS official documentation.=20
I just figured out that delaylog feature is now included and there is no wa=
y to disable it (http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux=
.git/tree/Documentation/filesystems/xfs.txt?id=3DHEAD).=20

Whatever the information it could be=2C I understood that this is a tempora=
ry memory located in RAM.=20
Recently=2C I had a crash on a server and I had to execute the repair proce=
dure which worked fine.=20

But I would like to disable this feature to prevent any temporary data not =
to be written do disk. (Write cache is already disabled on both hard drive =
and raid controller).=20

Perhaps it's a bad idea disabling it. If so=2C I would like to have your op=
inion about where memory corruption could happen.=20

Any help would be much appreciated.=20
Thank you.=20

 		 	   		  =

--_9cc6956f-f6c3-4c31-94ca-98ec519df573_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Hello. <br><br>I just wanted to =
have more information about the delaylog feature. <br>From what I understoo=
d it seems to be a common feature from different FS. It's supposed to retai=
n information such as metadata for a time ( how much ?). Unfortunately=2C I=
 could not find further information about journaling log section in the XFS=
 official documentation. <br>I just figured out that delaylog feature is no=
w included and there is no way to disable it (http://git.kernel.org/cgit/li=
nux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/xfs.txt?id=
=3DHEAD). <br><br>Whatever the information it could be=2C I understood that=
 this is a temporary memory located in RAM. <br>Recently=2C I had a crash o=
n a server and I had to execute the repair procedure which worked fine. <br=
><br>But I would like to disable this feature to prevent any temporary data=
 not to be written do disk. (Write cache is already disabled on both hard d=
rive and raid controller). <br><br>Perhaps it's a bad idea disabling it. If=
 so=2C I would like to have your opinion about where memory corruption coul=
d happen. <br><br>Any help would be much appreciated. <br>Thank you. <br><b=
r> 		 	   		  </div></body>
</html>=

--_9cc6956f-f6c3-4c31-94ca-98ec519df573_--


--===============5355556345169456692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5355556345169456692==--
