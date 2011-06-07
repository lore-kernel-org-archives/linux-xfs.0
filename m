Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57Bsiac023393 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 06:54:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C93615DF3F1
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 04:54:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	shxGZTmTHKusOXyE for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2011 04:54:43 -0700 (PDT)
Date: Tue, 7 Jun 2011 07:54:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: accounting of reclaimable inodes is incorrect
Message-ID: <20110607115441.GA4653@infradead.org>
References: <4DEE0EA4.9090002@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DEE0EA4.9090002@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

On Tue, Jun 07, 2011 at 01:42:28PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> it seems that a bug was backported into the latest 2.6.32 longterm
> stable kernel. Now the patch "XFS: accounting of reclaimable inodes
> is incorrect" needs to get backported to 2.6.32.
> 
> Who can help? Who is responsible?

For -stable releases no one really is.  If you want to help you can
backport it and send it to the stable mailinglist.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
