Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OEsrv0127969 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 09:54:53 -0500
Date: Tue, 24 Jul 2012 09:54:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120724145450.GN29979@sgi.com>
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
	<20120702070502.GA25568@infradead.org>
	<20120702082952.GR19223@dastard> <4FF1A74C.1070003@redhat.com>
	<20120717065959.GA29748@infradead.org>
	<20120724132246.GA9142@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120724132246.GA9142@infradead.org>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 24, 2012 at 09:22:46AM -0400, Christoph Hellwig wrote:
> On Tue, Jul 17, 2012 at 03:00:00AM -0400, Christoph Hellwig wrote:
> > Let's take the patch as-is for 3.6 as we have enough other work in that
> > area queued.  We can clean it up later if needed.
> 
> Ben, any reason this never got picked up?

A lost sheep!  I am planning on pulling this in for 3.6 just as you suggested.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
