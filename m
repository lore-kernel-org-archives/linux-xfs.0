Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86BtJth076218 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 06:55:19 -0500
Date: Tue, 6 Sep 2011 07:55:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/25] xfs: factor extent map manipulations out of
	xfs_bmapi
Message-ID: <20110906115517.GB12931@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.102703569@bombadil.infradead.org>
	<1315002191.2069.84.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315002191.2069.84.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Fri, Sep 02, 2011 at 05:23:11PM -0500, Alex Elder wrote:
> You included no signoff.  I am going to assume it included
> this like the rest of the series:
> 
>     Signed-off-by: Christoph Hellwig <hch@lst.de>

It's actually a patch from Dave that I didn't modify in any significant
way, so it should have his signoff.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
