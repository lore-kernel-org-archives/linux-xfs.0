Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CJsRAI063327 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 13:54:28 -0600
Date: Tue, 12 Jan 2010 14:55:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfsprogs: bump version and update changelog
Message-ID: <20100112195522.GA9594@infradead.org>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6954@cf--amer001e--3.americas.sgi.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6955@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6955@cf--amer001e--3.americas.sgi.com>
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

On Tue, Jan 12, 2010 at 01:07:44PM -0600, Alex Elder wrote:
> Alex Elder wrote:
> > Christoph Hellwig wrote:
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks good.
> > 
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> Whoops.  I'm going to also add this to the CHANGES file:
> 
>  - Use physical device sector size if available in mkfs.xfs,
>    so 4K sector devices are handed more gracefully.
> 
> Eric felt this wording was OK.

I'm going to fix the text up before commiting it, thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
