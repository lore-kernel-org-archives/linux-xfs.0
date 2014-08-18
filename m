Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E349C7F56
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 23:52:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C033F8F8035
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2014 21:52:39 -0700 (PDT)
Received: from BLU004-OMC4S37.hotmail.com (blu004-omc4s37.hotmail.com
	[65.55.111.176]) by cuda.sgi.com with ESMTP id 6LeH0OKxDw2wiGjO
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 17 Aug 2014 21:52:38 -0700 (PDT)
Message-ID: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
From: Prithvi Rathore <prithvi_rathore@outlook.com>
Subject: [RFD]: Help in setting up XFS
Date: Mon, 18 Aug 2014 10:22:37 +0530
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7331124217518720674=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7331124217518720674==
Content-Type: multipart/alternative;
	boundary="_778d5abc-5bb2-43e2-80ee-7e747e57d65a_"

--_778d5abc-5bb2-43e2-80ee-7e747e57d65a_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi=2C
As the subject states=2C I would like to setup and use XFS on an external U=
SB drive. I am currently using Ubuntu 14.04 on MacBook Air 2013.
My understanding is:

1) I will have to install the packages
$ sudo apt-get install xfsprogs
$ sudo apt-get install xfsdump

2) I will have to create the filesystem for the USB drive
$ mkfs.xfs -f dev/sdab1
-f option needed to overwrite any exisitng filesytem

I would appreciate if you could add any comments or guide me for the same. =
Thanking you in anticipation=20
 		 	   		  =

--_778d5abc-5bb2-43e2-80ee-7e747e57d65a_
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
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi=2C<br>As the subject states=
=2C I would like to setup and use XFS on an external USB drive. I am curren=
tly using Ubuntu 14.04 on MacBook Air 2013.<br>My understanding is:<br><br>=
1) I will have to install the packages<br>$ sudo apt-get install xfsprogs<b=
r>$ sudo apt-get install xfsdump<br><br>2) I will have to create the filesy=
stem for the USB drive<br>$ mkfs.xfs -f dev/sdab1<br>-f option needed to ov=
erwrite any exisitng filesytem<br><br>I would appreciate if you could add a=
ny comments or guide me for the same. Thanking you in anticipation <br> 		 =
	   		  </div></body>
</html>=

--_778d5abc-5bb2-43e2-80ee-7e747e57d65a_--


--===============7331124217518720674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7331124217518720674==--
