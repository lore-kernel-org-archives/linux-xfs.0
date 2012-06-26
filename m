Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QEjOs8112652 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 09:45:24 -0500
Date: Tue, 26 Jun 2012 09:46:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix comment typo of xfs_open_devices()
Message-ID: <20120626144659.GR10196@sgi.com>
References: <1340721305-3602-1-git-send-email-baozich@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340721305-3602-1-git-send-email-baozich@gmail.com>
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
To: Chen Baozi <baozich@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 26, 2012 at 10:35:05PM +0800, Chen Baozi wrote:
> Since "get_sb_bdev()" has been changed to "mount_bdev()", fix
> the comment accordingly.
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>

Looks good.  Thanks Chen!
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
