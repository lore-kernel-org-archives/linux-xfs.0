Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6Wc061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:22 -0500
Date: Mon, 29 Oct 2012 17:55:36 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 03/25] xfs: make buffer read verication an IO completion
	function
Message-ID: <20121030005535.GJ30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-4-git-send-email-david@fromorbit.com>
	<20121030002916.GE30227@caliban.engr.sgi.com>
	<20121030004546.GW29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030004546.GW29378@dastard>
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
Cc: xfs@oss.sgi.com, Phil White <pwhite@sgi.com>

On Tue, Oct 30, 2012 at 11:45:46AM +1100, Dave Chinner wrote:
> > This is OK with me so far, but I have comments on some of the callbacks.
> 
> /me looks around, doesn't find anything...
> 
> The comments must be elsewhere. ;)

You surmised correctly.
 
> BTW, Phil, can you trim away all the bits of the patch you aren't
> commenting on? Having to scroll through hundreds of lines of quoted
> email to find your replies is a little slow, and it's quite easy to
> miss comments when they are widely spread apart. Most people just
> quote the patch hunk they are making the comment about to avoid this
> problem....
 
Will do.  Sorry about that!

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
