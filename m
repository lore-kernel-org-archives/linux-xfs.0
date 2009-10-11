Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9BCMgDS221050 for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 07:22:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 151F14B8248
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2009 05:24:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3mRBQFtO5HwHeIvC for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2009 05:24:10 -0700 (PDT)
Date: Sun, 11 Oct 2009 08:24:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091011122409.GA22047@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD18C8D.90808@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Sun, Oct 11, 2009 at 09:43:09AM +0200, Patrick Schreurs wrote:
> Hello Christoph,
>
> Attached you'll find a screenshot from a 2.6.31.3 server, which includes  
> your patches and has XFS_DEBUG turned on. I truly hope this is useful to  
> you.

This is very helpful as the assertation that I put gets hit.   Thanks a
lot Patrick, I'll have another patch for you real soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
