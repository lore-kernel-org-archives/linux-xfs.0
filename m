Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K7qLeq001867 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 02:52:21 -0500
Date: Wed, 20 Jun 2012 03:52:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620075216.GA24798@infradead.org>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1338487534-14575-1-git-send-email-jengelh@inai.de>
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
To: Jan Engelhardt <jengelh@inai.de>
Cc: hch@infradead.org, joe@perches.com, bpm@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

I'd really like to get Jans type cleanups in XFS in for the next
merge window.  Given the lack of feedback on lkml in favor or
against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
and then do another push to propagate them to kernel-wide types later.

Is that fine with everybody?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
