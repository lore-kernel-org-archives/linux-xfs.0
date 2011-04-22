Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3M6hl1X202515 for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 01:43:47 -0500
Date: Fri, 22 Apr 2011 02:47:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: drop "Mount point match" from 028 and 047
	golden output
Message-ID: <20110422064714.GA14189@infradead.org>
References: <4023dc38fede89959ba21dbec1fd57b82e9dcff4.1303412002.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4023dc38fede89959ba21dbec1fd57b82e9dcff4.1303412002.git.aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 21, 2011 at 01:53:31PM -0500, Alex Elder wrote:
> Bill Kendall's latest update to xfsdump dropped a line of output
> that served no real purpose.  This change updates the golden output
> for the two tests that included that line of output.
> 
> Updated to filter out that line from dump output also, so old
> versions of the code will still produce the same output (suggested
> by Dave Chinner).

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
