Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AEIQjd182012 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:18:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CD50145BFD6
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 07:25:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4A407jYp5g4lvHHa for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 07:25:36 -0700 (PDT)
Date: Mon, 10 Oct 2011 10:18:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5, v3] repair: sector size and blkmap fixes
Message-ID: <20111010141825.GF31429@infradead.org>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318208915-14975-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Any chance we can get some coverage for the losts of extents cases
in xfstests?  It will probably require pre-created images, but I'd
really hate not beeing able to regression test this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
