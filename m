Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07Cr4FA051755 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 06:53:04 -0600
Date: Fri, 7 Jan 2011 07:55:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: Add log level to assertion printk
Message-ID: <20110107125513.GB6811@infradead.org>
References: <20110107143041.1d07e34f@kryten>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107143041.1d07e34f@kryten>
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
To: Anton Blanchard <anton@samba.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>

On Fri, Jan 07, 2011 at 02:30:41PM +1100, Anton Blanchard wrote:
> 
> I received a ppc64 bug report involving xfs but the assertion was filtered out
> by the console log level. Use KERN_CRIT to ensure it makes it out.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
