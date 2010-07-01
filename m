Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o61D0g8f195213 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 08:00:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9E331E1AB9E
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 06:03:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gyDxzBjgFNdm96tz for
	<xfs@oss.sgi.com>; Thu, 01 Jul 2010 06:03:29 -0700 (PDT)
Date: Thu, 1 Jul 2010 09:03:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: vmalloc, xfs_buf_get: failed to map pages
Message-ID: <20100701130328.GA31117@infradead.org>
References: <20100619150119.3ce64102@x2.grafnetz>
	<20100621072118.GA1361@infradead.org>
	<20100701134530.5f794758@x2.grafnetz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100701134530.5f794758@x2.grafnetz>
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
To: Mario Bachmann <grafgrimm77@gmx.de>
Cc: xfs@oss.sgi.com

On Thu, Jul 01, 2010 at 01:45:30PM +0200, Mario Bachmann wrote:
> Hi again, 
> 
> what is a good value for vmalloc= ? 
> The machine has 1 GB of RAM. 

try vmalloc=256M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
