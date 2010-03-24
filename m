Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2OFi2jm003818 for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 10:44:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB47E272398
	for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 08:45:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZZfzFAX01oC1DIpy for
	<xfs@oss.sgi.com>; Wed, 24 Mar 2010 08:45:43 -0700 (PDT)
Date: Wed, 24 Mar 2010 11:45:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: drop readlink of test devices
Message-ID: <20100324154543.GB9168@infradead.org>
References: <4BA986F1.4080407@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BA986F1.4080407@sandeen.net>
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

On Tue, Mar 23, 2010 at 10:28:49PM -0500, Eric Sandeen wrote:
> Comments say it's for devfs; it's actually breaking lvm devices, now.
> I think we can just drop it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Yes, let's nuke it.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
