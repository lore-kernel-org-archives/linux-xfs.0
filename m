Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RLj57o172927 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 16:45:05 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	e5NoB2OcAQJALPkg for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 14:45:03 -0700 (PDT)
Date: Wed, 28 Mar 2012 08:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: add lots of attribute trace points
Message-ID: <20120327214501.GF5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-9-git-send-email-david@fromorbit.com>
	<20120327211844.GC7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327211844.GC7762@sgi.com>
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

On Tue, Mar 27, 2012 at 04:18:44PM -0500, Ben Myers wrote:
> On Thu, Mar 22, 2012 at 04:15:13PM +1100, Dave Chinner wrote:
> > +DEFINE_ATTR_EVENT(xfs_attr_sf_removename);
> 
> This one is unused ^^^

An oversight due to copy-n-paste enthusiasm. Just remove it, or do
you want me to send a new patch with it removed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
