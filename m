Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBEJFN88144415 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 13:15:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 855B51EAFC9
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 11:17:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xSF7CWWF6EolsNs9 for
	<xfs@oss.sgi.com>; Tue, 14 Dec 2010 11:17:16 -0800 (PST)
Date: Tue, 14 Dec 2010 14:17:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: fix 108 through config mechanism
Message-ID: <20101214191713.GA26513@infradead.org>
References: <1291905612.3196.49.camel@dhcp-31-190.brq.redhat.com>
	<20101210143717.GB1415@infradead.org>
	<1292338417.3296.57.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292338417.3296.57.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 14, 2010 at 03:53:37PM +0100, Boris Ranto wrote:
> I didn't like it much either but I found it quite easy to implement with quite high probability of future usage.
> 
> I found the following modification sufficient although I'm not sure I put the _filter_spaces in right place (I'd say it's quite universal so it could find a usage in other cases):

This patch looks good to me.  Can you resent it in the correct format:

 - a descriptive subject
 - mail body containing a short explanation, than the signed-off-by
   line, then the actual patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
