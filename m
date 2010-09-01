Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81AIxll127898 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 05:19:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4134421E2
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 03:19:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nVdcX7JBaVAaiEio for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 03:19:39 -0700 (PDT)
Date: Wed, 1 Sep 2010 06:19:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Validate string -> number conversion. [version 3]
Message-ID: <20100901101938.GD31648@infradead.org>
References: <20100826082612.GE705@dastard>
	<1282942476-5296-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282942476-5296-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Fri, Aug 27, 2010 at 10:54:36PM +0200, Arkadiusz Mi??kiewicz wrote:
> Make sure that numbers passed as string will fit into proper
> types when doing string->uid_t/gid_t/prid_t conversion.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
