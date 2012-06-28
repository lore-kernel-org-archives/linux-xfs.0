Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5SGXkN1044015 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 11:33:47 -0500
Received: from tetsuo.zabbo.net (50-193-208-193-static.hfc.comcastbusiness.net
	[50.193.208.193]) by cuda.sgi.com with ESMTP id
	NqCFr9Q5mHtoj7Gx for <xfs@oss.sgi.com>;
	Thu, 28 Jun 2012 09:33:45 -0700 (PDT)
Message-ID: <4FEC8768.8000109@zabbo.net>
Date: Thu, 28 Jun 2012 09:33:44 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: cleanup the mount options
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
	<4FEBAB3B.6020707@cn.fujitsu.com> <20120628160156.GC29979@sgi.com>
In-Reply-To: <20120628160156.GC29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, xfs@oss.sgi.com


> It's not a strong objection from me, but I do have a preference for keeping the
> XFS_MOUNT_ prefix to retain context for cscope and grep.  Maybe others feel
> differently.

For what it's worth, I agree.  It's really annoying to have cscope
lookups fail and have to go poking around for things manually.

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
