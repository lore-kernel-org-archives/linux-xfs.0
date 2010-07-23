Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NJH9HS217778 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 14:17:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16C83C1FAE3
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 12:27:08 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id mhYrKQw3Drko1x7d for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 12:27:08 -0700 (PDT)
Message-ID: <4C49EB67.6020509@sandeen.net>
Date: Fri, 23 Jul 2010 14:20:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [RFC, PATCH 0/3] serialise concurrent direct IO sub-block zeroing
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1279881678-1660-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> Patches for discussion seeing as git.kernel.org is being slow to update.
> 

I can confirm that this fixes the qemu problems, too.

Also makes the install take about 30min vs. 10 ;)


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
