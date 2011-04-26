Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QFBHBE170685 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 10:11:17 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBC06510807
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 08:14:48 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id h2koM0Rl2ifYvWVM for
	<xfs@oss.sgi.com>; Tue, 26 Apr 2011 08:14:48 -0700 (PDT)
Date: Tue, 26 Apr 2011 08:14:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104260812130.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Dave,

On Mon, 25 Apr 2011 at 00:19, Christian Kujau wrote:
> Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/
> 
>  - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and
>    /proc/fs/xfs/stat (is this interesting at all?) and a few other
>    /proc outputs
>  - messages-4.txt, contains the syslog from this run.

did you have time to look at those outputs yet? Do you need some more 
information? Right now 2.6.39-rc4 is not an option for me, 2.6.38 works 
just fine....

Thanks,
Christian.
-- 
BOFH excuse #170:

popper unable to process jumbo kernel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
