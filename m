Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0U0MkeI238752 for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 18:22:47 -0600
Received: from snt0-omc4-s51.snt0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A38E61A4DA92
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:25:10 -0800 (PST)
Received: from snt0-omc4-s51.snt0.hotmail.com (snt0-omc4-s51.snt0.hotmail.com
	[65.54.51.102]) by cuda.sgi.com with ESMTP id GxywG22BOr2w5qvZ
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:25:10 -0800 (PST)
Message-ID: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
From: lord worm <cryptopsy@live.com>
Subject: how to decode metadump info produced by xfs_db, and superblock error
Date: Sat, 29 Jan 2011 19:25:10 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1151307947740465291=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1151307947740465291==
Content-Type: multipart/alternative;
	boundary="_635d24fa-5854-42c3-903f-e2724fd8e034_"

--_635d24fa-5854-42c3-903f-e2724fd8e034_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


What kind of information is in this file produced by metadump=2C is it wort=
h reading it somehow?

I'm trying to first understand what's causing a 'superblock cannot be read'=
 error in my XFS after a succesfully dd of the partition (dd succeeds in co=
pying to a file=2C and also restoring=2C but after restoring it cannot moun=
t).

xfs_repair fails to fix it=2C how should I attach the 55M metadata file to =
this email (do we have an upload location for this?)=2C max size on hotmail=
 is 25M ...

Does the superblock error refer to primary or secondary superblocks? Does x=
fs_repair attempt to clone the broken superblock from the others?
 		 	   		  =

--_635d24fa-5854-42c3-903f-e2724fd8e034_
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
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>
What kind of information is in this file produced by metadump=2C is it wort=
h reading it somehow?<br><br>I'm trying to first understand what's causing =
a 'superblock cannot be read' error in my XFS after a succesfully dd of the=
 partition (dd succeeds in copying to a file=2C and also restoring=2C but a=
fter restoring it cannot mount).<br><br>xfs_repair fails to fix it=2C how s=
hould I attach the 55M metadata file to this email (do we have an upload lo=
cation for this?)=2C max size on hotmail is 25M ...<br><br>Does the superbl=
ock error refer to primary or secondary superblocks? Does xfs_repair attemp=
t to clone the broken superblock from the others?<br> 		 	   		  </body>
</html>=

--_635d24fa-5854-42c3-903f-e2724fd8e034_--


--===============1151307947740465291==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1151307947740465291==--
