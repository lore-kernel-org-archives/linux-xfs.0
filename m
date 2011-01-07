Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07CqlV6051726 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 06:52:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36A541D1627D
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 04:54:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AkJiSPBKe6J6oFxe for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 04:54:57 -0800 (PST)
Date: Fri, 7 Jan 2011 07:54:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 241: run longer
Message-ID: <20110107125456.GA6811@infradead.org>
References: <4D25FF79.6070207@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D25FF79.6070207@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 06, 2011 at 11:44:25AM -0600, Eric Sandeen wrote:
> I ran into a failure on an ext4 backport which should have
> been caught by this test, but 30s wasn't long enough to
> hit it reliably.  So run a bit longer; it's not in the
> quick group anyway.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
