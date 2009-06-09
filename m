Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5988hZf021383 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 03:08:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AB678D1B3B
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 01:16:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bcv9Apk2hdOYriQn for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 01:16:07 -0700 (PDT)
Date: Tue, 9 Jun 2009 04:09:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fwd: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090609080901.GA2025@infradead.org>
References: <Pine.LNX.4.62.0906051023170.19804@sci.felk.cvut.cz>
	<1001284815.6030901244505808497.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1001284815.6030901244505808497.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 09, 2009 at 10:03:28AM +1000, Nathan Scott wrote:
> Could someone verify and merge this patch?  It looks OK to
> me.

Andreas now takes care ot attr.  Btw, the submitter should stop that
stupid GNU wanking - errnos are defined by the kernel so it's a FreeBSD
issues and has nothing to do with their glibc abuse.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
