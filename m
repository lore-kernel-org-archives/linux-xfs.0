Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o47BYBGX160463 for <xfs@oss.sgi.com>; Fri, 7 May 2010 06:34:11 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E1591DE64DA
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 04:36:20 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id mwekYfDXDFXYpsrC
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 04:36:20 -0700 (PDT)
Received: by wyb36 with SMTP id 36so556176wyb.26
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 04:36:19 -0700 (PDT)
Message-ID: <4BE3FB32.8030709@gmail.com>
Date: Fri, 07 May 2010 13:36:18 +0200
From: Pol <polmail@gmail.com>
MIME-Version: 1.0
Subject: Please Help
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4134510554362249510=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============4134510554362249510==
Content-Type: multipart/alternative;
 boundary="------------090901010707050403020108"

This is a multi-part message in MIME format.
--------------090901010707050403020108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Good morning.
I'm writing from Barcelona and English is not my born language, so I'd 
like to apologize in advance for any possible mistakes in my text.

I'm a Windows user who has recently moved to Linux (Ubuntu 10.04), and I 
have a serious problem regarding my Hard Drives' File System.
I have a desktop version of Ubuntu and I'm a complete regular user.

I have two physical drives in my system:
1. 36GB: EXT4 partition for /, another EXT4 for /home and a SWAP one.
2. 1TB (for data) drive.

I generate so much video and music data per month (AVI, MKV, MP3, WAV) 
because of my job, and need to copy it to external hard drives to ensure 
I don't lose any of it.

My question is about the FS to use in these data drives.
I currently have all of them in XFS fyle system. Every file I generate 
is saved in my internal XFS drive, and whenever the hd is almost full I 
copy the important files to External Hard Drives which are also 
formatted as XFS.

My problem comes after reading a couple of posts from 2006 in some 
forums on the web. They said that XFS is very unsecure when a power 
failure happens and recommended EXT3 (EXT4 these days I guess). They 
said that after a power failure it's very common to see data loss 
(something that never happened to me in all my years using NTFS).

As far as I know XFS is much more secure than NTFS so I don't really 
understand this issue. I assume these people were talking about systems 
which need to be continously writing to the disk, but my knowledge about 
this is very limited.

Did I chose the correct FS for my drives?


Thank you very much for your time.

--------------090901010707050403020108
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body bgcolor="#ffffff" text="#000000">
<font size="-1">Good morning.<br>
I'm writing from Barcelona and English is not my born language, so I'd
like to apologize in advance for any possible mistakes in my text.<br>
<br>
I'm a Windows user who has recently moved to Linux (Ubuntu 10.04), and
I have a serious problem regarding my Hard Drives' File System.<br>
I have a desktop version of Ubuntu and I'm a complete regular user.<br>
<br>
I have two physical drives in my system:<br>
1. 36GB: EXT4 partition for /, another EXT4 for /home and a SWAP one.<br>
2. 1TB (for data) drive.<br>
<br>
I generate so much video and music data per month (AVI, MKV, MP3, WAV)
because of my job, and need to copy it to external hard drives to
ensure I don't lose any of it.<br>
<br>
My question is about the FS to use in these data drives.<br>
I currently have all of them in XFS fyle system. Every file I generate
is saved in my internal XFS drive, and whenever the hd is almost full I
copy the important files to External Hard Drives which are also
formatted as XFS.<br>
<br>
My problem comes after reading a couple of posts from 2006 in some
forums on the web. They said that XFS is very unsecure when a power
failure happens and recommended EXT3 (EXT4 these days I guess). They
said that after a power failure it's very common to see data loss
(something that never happened to me in all my years using NTFS).<br>
<br>
As far as I know XFS is much more secure than NTFS so I don't really
understand this issue. I assume these people were talking about systems
which need to be continously writing to the disk, but my knowledge
about this is very limited.<br>
<br>
Did I chose the correct FS for my drives?<br>
<br>
<br>
Thank you very much for your time.<br>
</font>
</body>
</html>

--------------090901010707050403020108--


--===============4134510554362249510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4134510554362249510==--
