Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4DSITt032548 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 07:28:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1B8B1BEECF9
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 05:28:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kmTEF7vc0QjEW9f4 for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 05:28:17 -0800 (PST)
Date: Thu, 4 Dec 2008 08:27:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove XFS_BUF_SHUT() and friends
Message-ID: <20081204132746.GA27400@infradead.org>
References: <49378654.2050707@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49378654.2050707@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 06:27:16PM +1100, Lachlan McIlroy wrote:
> Code does nothing so remove it.

Looks good to me.  Does anyone remember why this flag was set on IRIX?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
