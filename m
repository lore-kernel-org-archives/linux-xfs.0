Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96K3KlN199216 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 15:03:20 -0500
Subject: Re: [PATCH] xfstests: prepare for marking an initial versioned release
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006195229.GJ13434@infradead.org>
References: <201110052243.p95MhBtl015550@stout.americas.sgi.com>
	<20111006195229.GJ13434@infradead.org>
Date: Thu, 6 Oct 2011 15:03:14 -0500
Message-ID: <1317931394.2870.30.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, 2011-10-06 at 15:52 -0400, Christoph Hellwig wrote:
> On Wed, Oct 05, 2011 at 05:43:11PM -0500, Alex Elder wrote:
> > I would like to start marking versioned releases of xfstests.  The
> > following adds the release script used in the other XFS user space
> > packages.  I have arbitrarily set the version to 3.0.0 to make it
> > more in line with the other XFS user space packages as well.  I
> > created an initial CHANGES file with a simple summary of some
> > recently-added tests.
> 
> Whye the bump to 3.x?

Like I said, it was somewhat just to align it better with
the other XFS user space packages.  One could also think
about lining it up with kernel versions as well, and we
could plan on releasing a new edition of xfstests roughly
corresponding with the Linux releases.

But it really is arbitrary, and if you have a reason to
use something else, great, we'll use it.  If not, it
doesn't much matter.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
