Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P7sTiO127511 for <xfs@oss.sgi.com>; Wed, 25 May 2011 02:54:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F82314D9561
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 00:54:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id F77EQapoSxI8RStu for
	<xfs@oss.sgi.com>; Wed, 25 May 2011 00:54:29 -0700 (PDT)
Date: Wed, 25 May 2011 03:54:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add test 254 for testing basic btrfs volume
	functionality
Message-ID: <20110525075428.GA11150@infradead.org>
References: <1306268763-7932-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306268763-7932-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, May 24, 2011 at 04:26:03PM -0400, Josef Bacik wrote:
> This test just runs through all of the basic btrfs commands that manipulate our
> subvolume stuff.  It creates a snapshot, a subvolume, sets the subvolume as a
> default, lists the volumes and deletes the snapshot.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
