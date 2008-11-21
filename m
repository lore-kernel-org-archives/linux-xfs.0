Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALLKWB6010112 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:20:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A531A15C00BD
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 13:20:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PMDeG9jBwAuJ2i2W for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 13:20:31 -0800 (PST)
Date: Fri, 21 Nov 2008 16:20:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Announce: XFS staging tree
Message-ID: <20081121212030.GA17816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>

I've created a new tree of all patches that have been reviewed, and
properly QAed but haven't been merged into the SGI tree for reasons
unknown to us patch submitters.

QAed means they pass xfsqa without regressions on x86 and ppc64.


The patch series is available under

	http://www.kernel.org/pub/linux/kernel/people/hch/xfs/xfs-staging-20081121/

for the specific version I just released for today, or

	http://www.kernel.org/pub/linux/kernel/people/hch/xfs/xfs-staging/

for an always current version.  Tarballs are also avaiable under

	http://www.kernel.org/pub/linux/kernel/people/hch/xfs/

I'll add all patches that have gotten review on linux-xfs to it after
they pass xfsqa for me.   Patches will be dropped as soon as they get
into the xfs git tree.

Stephen, can you add these to linux-next so that the patches get a
little wider testing base?

Cheers,
	Christoph

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
