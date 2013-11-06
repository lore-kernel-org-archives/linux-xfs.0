Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3F1929E26
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 05:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C969AC002
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 03:20:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 88mArnKjjARshaDJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 03:20:32 -0800 (PST)
Date: Wed, 6 Nov 2013 03:20:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ***** SUSPECTED SPAM ***** [RFD 11/17] xfs: factor xfs_create to
	prepare for O_TMPFILE
Message-ID: <20131106112030.GA24805@infradead.org>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
	<1376313607-28133-12-git-send-email-david@fromorbit.com>
	<CAEH94Lie4UoVBicXohLwOVMWtcuu+fNnkBhK+QV8kV+k0AaB0A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94Lie4UoVBicXohLwOVMWtcuu+fNnkBhK+QV8kV+k0AaB0A@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>

On Tue, Aug 20, 2013 at 04:16:59PM +0800, Zhi Yong Wu wrote:
> HI,
> 
> I'd like to pick off this item and its following 2 items, please avoid
> the duplicated work, thanks.
> 
> [RFD 11/17] xfs: factor xfs_create to prepare for O_TMPFILE,
> [RFD 12/17] xfs: add tmpfile methods
> [RFD 13/17] xfs: allow linkat() on O_TMPFILE files

Did you make any progress on this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
