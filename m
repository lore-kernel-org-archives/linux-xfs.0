Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PGFLp1014236 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 10:15:21 -0600
Date: Wed, 25 Jan 2012 10:15:21 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path
	in xfs_readlink()
Message-ID: <20120125161521.GV8262@sgi.com>
References: <1326307930-21251-1-git-send-email-jack@suse.cz>
	<20120111191330.GQ20739@sgi.com>
	<20120124180102.GB23671@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124180102.GB23671@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, stable@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 01:01:02PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 11, 2012 at 01:13:30PM -0600, Ben Myers wrote:
> > Looks good to me.
> > 
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> Can you send it on to Linus ASAP, please?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
