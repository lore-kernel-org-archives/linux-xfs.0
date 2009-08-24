Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OFTduN132812 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 10:29:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D8FE3F232A
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 08:30:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tXBZrtfrIJWfAy7I for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 08:30:31 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MfbV8-000696-SN
	for xfs@oss.sgi.com; Mon, 24 Aug 2009 15:30:30 +0000
Date: Mon, 24 Aug 2009 11:30:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] inode allocation cleanups
Message-ID: <20090824153030.GA19864@infradead.org>
References: <20090512211607.197071000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090512211607.197071000@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

ping?  any reviewers for this?

On Tue, May 12, 2009 at 05:16:07PM -0400, Christoph Hellwig wrote:
> 
> This series contains various cleanups and refactorings to xfs_ialloc.c,
> some of them are my own and some are from Dave Chinner.
> 
> The last patch is also from Dave and speeds up the search for free inodes
> in allocation groups with lots of inodes.  I ported it ontop of all
> the previous patches, which made it a lot cleaner.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
