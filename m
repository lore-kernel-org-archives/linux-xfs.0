Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AG8wdr068881 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 11:08:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3DCBB22B55
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:19:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GbKchg0JQVbu8MU0 for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:19:47 -0700 (PDT)
Date: Mon, 10 Aug 2009 12:09:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
Message-ID: <20090810160949.GA21948@infradead.org>
References: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<4A80291D.6020200@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A80291D.6020200@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, Lachlan McIlroy <lmcilroy@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 10, 2009 at 09:05:17AM -0500, Eric Sandeen wrote:
> Lachlan McIlroy wrote:
> > This looks good Eric.
> > 
> > Is this test just for quota accounting or should it be testing quota
> > enforcement too?
> 
> I guess 108 just did accounting; I was going to keep it parallel, and do
> a different one for accounting, but it could be added to this as well.

Yeah, let's use a different one for enforement testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
