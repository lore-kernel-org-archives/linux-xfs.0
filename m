Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99nXlc013127 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:49:33 -0600
Date: Tue, 9 Dec 2008 04:49:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: What's left for 2.6.29?
Message-ID: <20081209094932.GA21925@infradead.org>
References: <493DE01B.6050303@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493DE01B.6050303@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 09, 2008 at 02:03:55PM +1100, Mark Goodwin wrote:
> 
> I think we need to freeze and start testing, i.e. git-cherry from
> the master branch over to for-linus and start some soak, stress
> amd regression testing. What's still left? Outstanding reviews?

I've resent my current 2.6.29 queue.

> Dave, ...?

Dave, a while ago you mentioned you still had some sort of check
in xfs_iread pending from the new inode cache, but I don't remember
the details.  Maybe you could find and submit that one again?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
