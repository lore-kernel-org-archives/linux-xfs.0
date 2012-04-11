Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BMx5Jx125195 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 17:59:07 -0500
Date: Wed, 11 Apr 2012 18:59:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: kill XBF_LOCK
Message-ID: <20120411225903.GA16192@infradead.org>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<1334052213-26870-2-git-send-email-david@fromorbit.com>
	<4F844B02.2030301@sgi.com> <20120410222027.GR18323@dastard>
	<20120411200729.GJ28816@infradead.org>
	<20120411225132.GV18323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120411225132.GV18323@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Apr 12, 2012 at 08:51:32AM +1000, Dave Chinner wrote:
> Right. What I meant was that I need to resend the entire 12-13
> buffer cache patches I have in my queue right now so that they
> should all apply easily...

Can you make sure the allocation fix is first in the series?  That's
material for 3.4-rc and stable backports.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
