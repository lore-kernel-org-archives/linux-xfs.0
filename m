Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L9L6xm027627 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 04:21:07 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2G5djLtxQz1TcSA5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 02:21:05 -0700 (PDT)
Date: Thu, 21 Jun 2012 05:21:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120621092104.GA3621@infradead.org>
References: <20120621091803.GB10673@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120621091803.GB10673@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 21, 2012 at 07:18:03PM +1000, Dave Chinner wrote:
> I don't have time to come up with a fix for this right now, but it
> needs to be fixed before 3.5 releases. I don't have time because I'm
> going to be AFK next week, so I'd appreciate it if someone could
> look at fixing this in the mean time?

I'll handle it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
