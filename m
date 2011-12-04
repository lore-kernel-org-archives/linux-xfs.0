Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB4LGW8k059097 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 15:16:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03D721563230
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 13:16:31 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kk35QcqrNuxTBye8 for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 13:16:31 -0800 (PST)
Date: Sun, 4 Dec 2011 16:16:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfstests: use command line option for setting extra
	space
Message-ID: <20111204211630.GB13000@infradead.org>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321875088-30801-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 10:31:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Allow the extra free space to leave in large scratch filesystems to
> be specified by a command line option rather than just via an
> environment variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This probably should be documented in the help text.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
