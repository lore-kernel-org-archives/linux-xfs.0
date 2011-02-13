Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1DC2sDP047217 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 06:02:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 245D61560073
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 04:05:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TAAsynJzMvqr5oDX for
	<xfs@oss.sgi.com>; Sun, 13 Feb 2011 04:05:22 -0800 (PST)
Date: Sun, 13 Feb 2011 07:05:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch][xfstests-dev] aiodio_sparse2: fix up alignment for 4k
	logical block sized devices
Message-ID: <20110213120518.GA694@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49pqqy8byi.fsf@segfault.boston.devel.redhat.com>
	<x49tyga8gst.fsf@segfault.boston.devel.redhat.com>
	<x49y65m8k4m.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: xfs@oss.sgi.com

Thanks, applied all three patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
