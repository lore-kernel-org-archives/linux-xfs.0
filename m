Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79E8929E06
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:37:47 -0600 (CST)
Date: Fri, 6 Dec 2013 11:37:43 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/7] xfs: reinstate the ilock in xfs_readdir
Message-ID: <20131206173743.GS1935@sgi.com>
References: <20131206164819.371654241@bombadil.infradead.org>
	<20131206164905.863036624@bombadil.infradead.org>
	<20131206165333.GA6100@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206165333.GA6100@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 08:53:33AM -0800, Christoph Hellwig wrote:
> Oops, looks like quilt didn't preserve the From: line for Ben.  This
> wasn't intentional.

No worries. ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
