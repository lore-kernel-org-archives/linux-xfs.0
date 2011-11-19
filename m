Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJHp4VM069715 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 11:51:04 -0600
Date: Sat, 19 Nov 2011 12:51:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfsprogs v3.1.7
Message-ID: <20111119175102.GA3334@infradead.org>
References: <20111117233139.GL29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111117233139.GL29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 17, 2011 at 05:31:39PM -0600, Ben Myers wrote:
> Version 3.1.7 of xfsprogs has been released.

Can we please avoid totally uncoordinated and rushed release in
the future?  You personally had quetions about the lost+found
nlink issues that still haven't been resolved, and there's tons
of repair fixes that should have made it int othe next release.

If we only have a tiny debian specific fixup we should have a
Debian-specific branch with just that one liner.  Real releases
with actual changes need QA and coordination.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
