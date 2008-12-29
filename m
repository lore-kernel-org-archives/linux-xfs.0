Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTBbuBj001137 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 05:37:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 794371792538
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:37:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SIxFucEVCBHOEnvI for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:37:55 -0800 (PST)
Date: Mon, 29 Dec 2008 06:37:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: couple small xfstest patches
Message-ID: <20081229113754.GB10891@infradead.org>
References: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
	<20081222130824.GC12367@infradead.org>
	<494FAA58.7070605@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <494FAA58.7070605@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 22, 2008 at 08:55:20AM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Fri, Nov 21, 2008 at 01:45:23PM -0800, Matthew Kent wrote:
> >> * 189 fails with external devices
> >> * add a unified diff output option, find it easier on the eyes ;)
> > 
> > Thanks, I'll put these into my queue.  Question to the list:  any
> > arguments against just making unified diffs the default for xfsqa
> > output?
> 
> none here; I run patched that way already.

Given that no one else complained I'll make it the default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
