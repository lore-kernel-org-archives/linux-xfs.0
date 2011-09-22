Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGnvfx245145 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:49:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B4371C36D8A
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 09:49:31 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WFklbAzAGGHDHvPH for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2011 09:49:31 -0700 (PDT)
Date: Thu, 22 Sep 2011 12:49:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: System stuck in D state while deleting messages in mutt
Message-ID: <20110922164930.GC12353@infradead.org>
References: <20110919135622.GA13039@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110919135622.GA13039@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 19, 2011 at 03:56:22PM +0200, Markus Trippelsdorf wrote:
> My system just got stuck while I was trying to delete old messages in
> mutt. I'm running the latest git kernel. This happened on my SSD:

Stuck as in staying in it for a long time, or forever?

Are you using Maildir?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
