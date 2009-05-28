Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SFm9H9261349 for <xfs@oss.sgi.com>; Thu, 28 May 2009 10:48:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F304212614C6
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:54:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6Bp1MWt9iOsbp1yn for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 08:54:24 -0700 (PDT)
Date: Thu, 28 May 2009 11:48:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0.5/9] Replace MAXNAMELEN with NAME_MAX + 1
Message-ID: <20090528154823.GA25199@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-2-git-send-email-sandeen@sandeen.net>
	<20090528095657.GA651@infradead.org> <4A1EB1E6.6040606@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1EB1E6.6040606@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, May 28, 2009 at 10:46:46AM -0500, Eric Sandeen wrote:
> Drop the xfs-specific MAXNAMELEN in favor of the Posix NAME_MAX
> 
> This makes it easier to lose libxfs.h later.

Looks good.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
