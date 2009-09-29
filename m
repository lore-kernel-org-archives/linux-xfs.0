Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TCtfTg204999 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 07:55:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD95D14B5F1A
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:57:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sfeWe7CiZJ5H76oa for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:57:03 -0700 (PDT)
Date: Tue, 29 Sep 2009 08:57:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20090929125702.GC11375@infradead.org>
References: <89c4f90c0909160327l1a1fdaa2g131cd7fa249ad529@mail.gmail.com>
	<20090917185953.GA24590@infradead.org>
	<4AC1DE4E.6060102@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AC1DE4E.6060102@news-service.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Tue, Sep 29, 2009 at 12:15:42PM +0200, Patrick Schreurs wrote:
> Update: We've applied this patch on 2 servers. They didn't crash until  
> now. Today we've applied the patch on 6 other servers.

Thanks.  I'll prepare a patch for upstream as the patch is extremly
useful by itself.  IF other issues show up I'll fix it on top of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
