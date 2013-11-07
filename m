Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 696747FFD
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 14:59:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E95B7AC005
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 12:59:04 -0800 (PST)
Date: Thu, 7 Nov 2013 12:59:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107205903.GA32421@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard> <527A9F67.6000208@sgi.com>
	<20131107081634.GB25157@infradead.org> <527B94A5.20004@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527B94A5.20004@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 07:24:53AM -0600, Mark Tinguely wrote:
> >>>xfs/206 has it's own mkfs filter:
> >>>
> >>>http://oss.sgi.com/archives/xfs/2013-10/msg00777.html
> >
> >And why is this patch not merged?
> >
> 
> It was never reviewed.

Consider it reviewed:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
