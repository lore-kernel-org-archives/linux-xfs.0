Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n447eLoY160752 for <xfs@oss.sgi.com>; Mon, 4 May 2009 02:40:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F559146D8EE
	for <xfs@oss.sgi.com>; Mon,  4 May 2009 00:44:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id txuXFIwGgpL9lQMu for
	<xfs@oss.sgi.com>; Mon, 04 May 2009 00:44:13 -0700 (PDT)
Date: Mon, 4 May 2009 03:40:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: add .gitignore
Message-ID: <20090504074021.GA29449@infradead.org>
References: <20090429135050.GC30808@infradead.org>
	<d38e348a0905031635s3b7a812cl3e46d13069572d97@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d38e348a0905031635s3b7a812cl3e46d13069572d97@mail.gmail.com>
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
To: Timothy Shimmin <timothy.shimmin@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, May 04, 2009 at 09:35:39AM +1000, Timothy Shimmin wrote:
> Get rid of the symlinked files by creating a local library for the
> commonality? ;-)Probably easier said than done - I haven't looked at the
> code in a while - but I
> I think the traditional library model is better than a heap of symlinks :)

It probably is.  I'll put it on my todo list..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
