Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62EDDZh245785 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 09:13:13 -0500
Date: Fri, 2 Jul 2010 10:15:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100702141559.GA6259@infradead.org>
References: <1277762653.2040.554.camel@doink>
	<20100629075734.GA31118@infradead.org>
	<20100630002043.GB24712@dastard> <1278079547.1876.82.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278079547.1876.82.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 02, 2010 at 09:05:47AM -0500, Alex Elder wrote:
> Here is what I plan to do:
> - Accept Christoph's "drop dmapi hooks" patch into the
>   XFS master branch.  Once that's in, there's a huge
>   cascade of subsequent work that need to be pulled in
>   and I'll get those out there also.
> - Work on creating a complete and working dmapi branch.
>   Once we've got a fairly well-integrated whole, I will
>   publish that branch on the XFS git tree.  We will plan
>   to maintain that in parallel with the XFS master branch,
>   re-basing it on the master branch periodically.
> - I'll make an announcement on the list about the 
>   availability of the new branch.

Thanks.  I think I still have a few old patches for dmapi code from a
few years ago that I can repost to simplify that code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
