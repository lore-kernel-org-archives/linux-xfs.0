Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MEqTj1068669 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 09:52:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 516291E6C9D2
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 07:53:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TDxEcDfVs3gyLqTD for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 07:53:24 -0700 (PDT)
Date: Wed, 22 Sep 2010 10:53:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/16] xfs: metadata scalability V2
Message-ID: <20100922145322.GA29163@infradead.org>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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

On Wed, Sep 22, 2010 at 04:44:13PM +1000, Dave Chinner wrote:
> Note: The branch also contains Christoph's btree + dquot cleanups;
> they have been sitting in my tree being tested for quite some time
> now and have been tested all through this metadata scalability work.

These patches made it into the oss tree by now.  What's still absent
there is the punch hole + zero patches from you.  Alex, can you apply
these two?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
