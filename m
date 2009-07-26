Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6Q3TM4G246845
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jul 2009 22:29:22 -0500
Received: from mail-fx0-f208.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A32210C0ADB
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jul 2009 20:38:37 -0700 (PDT)
Received: from mail-fx0-f208.google.com (mail-fx0-f208.google.com
	[209.85.220.208]) by cuda.sgi.com with ESMTP id
	h9eCflA0invNg1Z2 for <linux-xfs@oss.sgi.com>;
	Sat, 25 Jul 2009 20:38:37 -0700 (PDT)
Received: by fxm4 with SMTP id 4so1962239fxm.20
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jul 2009 20:30:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 Jul 2009 11:30:03 +0800
Message-ID: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
Subject: How to solve "No space left" problem on my 32bit machine?
From: hank peng <pengxihan@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi, folks:
I have a 2.5T file system formatted with XFS, df tells me it still
have about 10G space available, but I can't create new files or
directory any more. Return message is "No space left on this device".
I searched solution for this problem through google, and found this:
http://oss.sgi.com/archives/xfs/2005-06/msg00347.html. I think it is a
known "No space left" problem. I wonder whether it can only
be solved on 64-bit machine? If on my 32-bit machine, what should I do?



-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
