Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUG2G2m188957 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 10:02:17 -0600
Date: Fri, 30 Nov 2012 10:04:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfs: fix sparse reported log CRC endian issue
Message-ID: <20121130160432.GR24185@sgi.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-5-git-send-email-david@fromorbit.com>
	<20121128133059.GC2765@infradead.org>
	<20121128213110.GV6434@dastard> <20121129203250.GI27055@sgi.com>
	<20121130160330.GA5667@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121130160330.GA5667@infradead.org>
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
Cc: xfs@oss.sgi.com

Hey Christoph,

On Fri, Nov 30, 2012 at 11:03:30AM -0500, Christoph Hellwig wrote:
> On Thu, Nov 29, 2012 at 02:32:50PM -0600, Ben Myers wrote:
> > This seems reasonable to me, and the patch looks fine.  Christoph, do have any
> > further objection?
> 
> No, although adding the explanation as a comment would be useful.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Cool.  I'll add it in then.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
