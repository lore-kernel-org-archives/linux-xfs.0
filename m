Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87HLnJ8173462 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:21:49 -0500
Subject: Re: [PATCH 04/25] xfs: factor extent map manipulations out of
	xfs_bmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110906115517.GB12931@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.102703569@bombadil.infradead.org>
	<1315002191.2069.84.camel@doink> <20110906115517.GB12931@infradead.org>
Date: Wed, 7 Sep 2011 12:21:44 -0500
Message-ID: <1315416104.2988.59.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Tue, 2011-09-06 at 07:55 -0400, Christoph Hellwig wrote:
> On Fri, Sep 02, 2011 at 05:23:11PM -0500, Alex Elder wrote:
> > You included no signoff.  I am going to assume it included
> > this like the rest of the series:
> > 
> >     Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> It's actually a patch from Dave that I didn't modify in any significant
> way, so it should have his signoff.
> 

OK.  I won't commit it without recording that.
Do you want your own signoff included also?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
