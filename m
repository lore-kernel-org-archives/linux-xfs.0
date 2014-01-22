Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92F427F67
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 05:52:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22B76AC002
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 03:52:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HPkGCR7Gh7wdXLrk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 03:52:39 -0800 (PST)
Date: Wed, 22 Jan 2014 03:52:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] xfstests: various fixes and additions for XFS
Message-ID: <20140122115238.GA24080@infradead.org>
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 20, 2014 at 05:22:30PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> The following series cleans up some of the infrastructure for
> handling XFS filesystems, and fixes a few failures that have
> resulted from recent changes to mkfs defaults. There is also a new
> log recovery test that uses fsstress to generate load and log
> traffic. This was causing failures and hangs on recent kernels.

The whole series looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
