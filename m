Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3E757F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:05:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFC168F8039
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:05:40 -0800 (PST)
Date: Fri, 29 Nov 2013 00:05:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfsprogs v3.2.0-alpha2
Message-ID: <20131129080538.GA31310@infradead.org>
References: <5293A699.20908@sgi.com> <20131128104002.GC26927@infradead.org>
	<20131128211858.GR10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128211858.GR10988@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 29, 2013 at 08:18:58AM +1100, Dave Chinner wrote:
> On Thu, Nov 28, 2013 at 02:40:02AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 25, 2013 at 01:35:53PM -0600, Rich Johnston wrote:
> > > Alpha version 3.2.0-alpha2 of xfsprogs has been released.
> > 
> > So what issues keep us issueing alpha release instead of making a proper
> > .0 release?
> 
> There's still things to fix in xfs_repair before we do a full
> release. Run xfs/291 recently?

Works fine for me on v4 super blocks, which is what I mostly care about
for now as that's what is in the field.  And we haven't sent fixed
for our existing installed base out for over 6 month now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
