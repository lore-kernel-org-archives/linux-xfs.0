Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08JBxm5023784 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:11:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4635C718BA
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:11:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hdc868Ls0odc08B7 for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 11:11:59 -0800 (PST)
Date: Thu, 8 Jan 2009 14:11:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nfs4acl: fix include/ symlink creation (again)
Message-ID: <20090108191158.GC10617@infradead.org>
References: <49664F40.40109@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49664F40.40109@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Jan 08, 2009 at 01:08:48PM -0600, Eric Sandeen wrote:
> We need the "default" target first, otherwise a simple "make -C include"
> only ran the sys target, missing disk, and failures ensued.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
