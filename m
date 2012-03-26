Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QHn2KQ044957 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 12:49:02 -0500
Date: Mon, 26 Mar 2012 12:49:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120326174914.GR8451@sgi.com>
References: <20120228174223.GA6148@infradead.org>
	<20120301212822.GM7762@sgi.com>
	<20120302074433.GA4117@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302074433.GA4117@infradead.org>
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

Hey Christoph,

On Fri, Mar 02, 2012 at 02:44:33AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 01, 2012 at 03:28:22PM -0600, Ben Myers wrote:
> > On my machine test 030 has regressed.  It passed on 3.1.7.
> 
> That's an older change.  I have a fix in my local tree, but it needs
> polishing so that it still works with older repair versions.

Have you had a chance to work on your fix for 030?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
