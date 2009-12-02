Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2F9ho8008103 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 09:09:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CB53190FB04
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 07:10:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rioYqEfH8LijaaDB for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 07:10:14 -0800 (PST)
Date: Wed, 2 Dec 2009 10:10:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] (resend) xfsprogs: make lazy-count=1 the default.
Message-ID: <20091202151014.GC16338@infradead.org>
References: <4B156FC3.8010402@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B156FC3.8010402@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 01, 2009 at 01:34:27PM -0600, Eric Sandeen wrote:
> With the xfstests fixed up, we should be able to do this now.

Thanks, this is long overdue and a good default for 3.1.0.

We should announce it prominently enough in CHANGES and the release
mail, though.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
