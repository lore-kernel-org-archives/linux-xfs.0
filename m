Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IEOxmk158181 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:25:00 -0500
Date: Sat, 18 Jul 2009 10:25:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] reduce bmv_count in xfs_vn_fiemap
Message-ID: <20090718142539.GB20905@infradead.org>
References: <4A5E2F01.7030107@sandeen.net>
	<bzybpnkhp62.fsf@fransum.emea.sgi.com>
	<4A5F3DBA.9040005@sandeen.net> <4A5F7B7B.6020903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A5F7B7B.6020903@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Olaf Weber <olaf@sgi.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 16, 2009 at 02:11:55PM -0500, Eric Sandeen wrote:
> V3: bump up by one to accomodate expected bmv header in core

That is probably woth a comment next to setting it in the code.

Otherwise looks good to me, and thanks for the fiemap tests so that
we get test coverage for this.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
