Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86ND7n4204605 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 18:13:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q9ycBfpRHCLg1JDU for <xfs@oss.sgi.com>;
	Thu, 06 Sep 2012 16:14:06 -0700 (PDT)
Date: Fri, 7 Sep 2012 09:14:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/18] xfstests: convert tests to use new results directory
Message-ID: <20120906231402.GR15292@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<1343294892-20991-18-git-send-email-david@fromorbit.com>
	<1346846436.1129.20.camel@localhost>
	<20120905230431.GK15292@dastard>
	<CAFZPdfj8bRW4s6fmKohRF9uqE4rr8nav2_c-hbs80h4k+6QWkA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFZPdfj8bRW4s6fmKohRF9uqE4rr8nav2_c-hbs80h4k+6QWkA@mail.gmail.com>
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
To: Boris Ranto <ranto.boris@gmail.com>
Cc: Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 06, 2012 at 02:34:12PM +0200, Boris Ranto wrote:
> btw: The installation does not seem to work with the posted patches
> (it expects the old '[0-9]??' tests to be in the root directory of
> xfstests). Do you have/work on any patch for that?

I haven't touched the makefiles/install scripts - that's the last
thing I planned to do once all the changes are sorted. Thanks for
reminding me it needs to be done, though. ;)

Cheers

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
