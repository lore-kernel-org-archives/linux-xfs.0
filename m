Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SCWmxm166398 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:32:48 -0500
Date: Mon, 28 Mar 2011 08:35:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: add online discard support
Message-ID: <20110328123557.GA11382@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.024991786@bombadil.infradead.org>
	<1301087092.2537.691.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301087092.2537.691.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 25, 2011 at 04:04:52PM -0500, Alex Elder wrote:
> This one looks good overall.  How about adding
> documentation to Documentation/filesystems/xfs.txt
> to describe the new mount options?

I've added it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
