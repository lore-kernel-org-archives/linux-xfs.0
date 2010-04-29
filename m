Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TF81Jp080602 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 10:08:02 -0500
Date: Thu, 29 Apr 2010 10:10:03 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH] xfstests: test extent size hints
Message-ID: <20100429151003.GC27637@sgi.com>
References: <20100429103444.GA8019@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100429103444.GA8019@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Apr 29, 2010 at 06:34:44AM -0400, Christoph Hellwig wrote:
| This is an adapted version of the reproduced in OSS BZ #874, which
| shows file corruption when using the extent size hint.
| 
| Geoffrey, can you say if licensing the small test program as GPLv2+
| is fine so that we can add it to xfstests?

Thanks for asking Christoph.  Please include an SGI copyright in both
the test script and the t_holes.c source.  The GPLv2+ license is fine.

/*
 *  Copyright (c) 2010 SGI.
 *  All rights reserved.
 */


-- 
Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	    http://www.sgi.com/products/storage/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
