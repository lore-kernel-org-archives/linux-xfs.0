Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIK91av241623 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 14:09:03 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uv2EaH0fuM554POB for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 12:09:01 -0800 (PST)
Date: Sun, 18 Dec 2011 15:09:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111218200900.GA7137@infradead.org>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111218150304.88343txdekn774sg@web.mail.umich.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218150304.88343txdekn774sg@web.mail.umich.edu>
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
To: Sean Thomas Caron <scaron@umich.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 03:03:04PM -0500, Sean Thomas Caron wrote:
> Thanks, Christoph. I'll try to get a kernel built tomorrow that
> incorporates these patches and give it some testing.

They are equivalent to the test patch I gave to you, just split into
two, properly documented and against 3.2-rc instead of 3.0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
