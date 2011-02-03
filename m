Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p13EnV9C188175
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 08:49:31 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE4ED1550A37
	for <linux-xfs@oss.sgi.com>; Thu,  3 Feb 2011 06:51:59 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id r6TJozrzhGUxoAXy for
	<linux-xfs@oss.sgi.com>; Thu, 03 Feb 2011 06:51:59 -0800 (PST)
Message-ID: <4D4AC105.1090804@lueckdatasystems.com>
Date: Thu, 03 Feb 2011 09:51:49 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
In-Reply-To: <20110203045836.GV11040@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

Greetings Dave-

BTW: I ended up testing with the latest 10.04 kernel.

The size diffrerence of both kernel packages is disturbing!

-rw-r--r-- 1 root root 31608926 2011-01-11 13:09 linux-image-2.6.32-28-generic-pae_2.6.32-28.55_i386.deb
-rw-r--r-- 1 root root     4160 2010-11-08 05:05 linux-image-generic-pae_2.6.32.26.28_i386.deb

Perhaps that is due to the only change-log entry that came through apticron to me that "bump kernel number in prep for xyz" type of a change comment.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
