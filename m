Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGhb4D174009 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:43:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E343F1DE0E42
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:45:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kSybrwqyGRb0mlaK for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:45:43 -0700 (PDT)
Date: Fri, 30 Apr 2010 12:45:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: be more explicit if RT mount fails due to config
Message-ID: <20100430164543.GA4753@infradead.org>
References: <4BDA54A4.3040204@sandeen.net>
	<20100430164002.GC14107@infradead.org>
	<4BDB08C4.6070900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BDB08C4.6070900@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 30, 2010 at 11:43:48AM -0500, Eric Sandeen wrote:
> Recent testers were slightly confused that a realtime
> mount failed due to missing CONFIG_XFS_RT; we can make
> that a little more obvious.
> 
> V2: drop the else as suggested by Christoph
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
