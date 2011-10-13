Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DB6pt1168011 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 06:06:52 -0500
Subject: Re: [PATCH 3/3 v2] xfstests: allow 091 for non-xfs filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111011141840.GA14750@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111010182233.GB1335@infradead.org>
	<20111011141840.GA14750@infradead.org>
Date: Thu, 13 Oct 2011 06:06:45 -0500
Message-ID: <1318504005.3172.29.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-10-11 at 10:18 -0400, Christoph Hellwig wrote:
> The tests in 091 are entirely generic and pass e.g. on ext4 and jfs.
> btrfs fails it, but that looks a like a btrfs-specific issue to me.
> 
> Also use _supported_os properly instead of erroring out manually on
> IRIX.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
