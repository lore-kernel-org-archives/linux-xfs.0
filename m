Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NMp81G070699
	for <linux-xfs@oss.sgi.com>; Sat, 23 Oct 2010 17:51:08 -0500
Message-ID: <4CC3674A.2050305@gmail.com>
Date: Sun, 24 Oct 2010 00:52:58 +0200
From: alb348@gmail.com
MIME-Version: 1.0
Subject: Extended Attributes across filesystems
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7243949548986475605=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============7243949548986475605==
Content-Type: multipart/alternative;
 boundary="------------020807060305050405060105"

This is a multi-part message in MIME format.
--------------020807060305050405060105
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am doing some research into filesystems, and I understand that you are 
amongst the leading experts on the topic.

I would be really grateful if you could help me by answering some quick 
questions regarding Extended Attributes:

1) Apart from the maximum number / size limitations affecting some 
filesystems (ext2, ext3, ext4), as mentioned in attr5 / man5 section of 
the Linux manual online, are there any other relevant differences across 
the filesystems that may create problems in transfering Extended 
Attributes (along with the files) across filesystems?

2) Will the attr (also called xattr) functions work equally well on all 
the filesystems that support EA? In other words, are the EA-management 
implementations across the Unix filesystems sufficiently standardized?

3) As far as you know, is there any operating system, apart from 
BeOS/Haiku, where the indexing and querying processes of EAs are managed 
by the operating system itself? Do you think that this particular 
feature of Haiku is a really a significant advantage or not so much?

I imagine that you are very busy with you work, and I would really 
appreciate your help.

Looking forward to your reply, I wish you all the best.

Regards,

Tes Bezier



--------------020807060305050405060105
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body bgcolor="#000000" text="#999999">
    Hi,<br>
    <br>
    I am doing some research into filesystems, and I understand that you
    are amongst the leading experts on the topic. <br>
    <br>
    I would be really grateful if you could help me by answering some
    quick questions regarding Extended Attributes:<br>
    <br>
    1) Apart from the maximum number / size limitations affecting some
    filesystems (ext2, ext3, ext4), as mentioned in attr5 / man5 section
    of the Linux manual online, are there any other relevant differences
    across the filesystems that may create problems in transfering
    Extended Attributes (along with the files) across filesystems?<br>
    <br>
    2) Will the attr (also called xattr) functions work equally well on
    all the filesystems that support EA? In other words, are the
    EA-management implementations across the Unix filesystems
    sufficiently standardized?<br>
    <br>
    3) As far as you know, is there any operating system, apart from
    BeOS/Haiku, where the indexing and querying processes of EAs are
    managed by the operating system itself? Do you think that this
    particular feature of Haiku is a really a significant advantage or
    not so much?<br>
    <br>
    I imagine that you are very busy with you work, and I would really
    appreciate your help.<br>
    <br>
    Looking forward to your reply, I wish you all the best.<br>
    <br>
    Regards,<br>
    <br>
    Tes Bezier<br>
    <br>
    <br>
  </body>
</html>

--------------020807060305050405060105--


--===============7243949548986475605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7243949548986475605==--
