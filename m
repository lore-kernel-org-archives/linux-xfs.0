Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11LFo6m009583 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 15:15:51 -0600
Date: Wed, 1 Feb 2012 16:15:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfs: remove an unneeded NULL check
Message-ID: <20120201211540.GA3619@infradead.org>
References: <20120128105501.GB25092@elgon.mountain>
	<20120131225601.GQ9090@dastard>
	<20120201104500.GA13672@infradead.org>
	<20120201211326.GU9090@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120201211326.GU9090@dastard>
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
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dan Carpenter <dan.carpenter@oracle.com>

On Thu, Feb 02, 2012 at 08:13:26AM +1100, Dave Chinner wrote:
> > > There's a set of reviewed patches (for 3.3) that change all this
> > > code. The null check might still be there, but that needs to be
> > > checked.
> > 
> > Which series is that?  I mut have to admit I've lost track by now.
> 
> The removal of all the old log code.

That stuff actually still went into 3.3-rc1.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
