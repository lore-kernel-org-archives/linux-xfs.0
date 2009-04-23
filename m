Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHB4Zi016406 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:11:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F066A1CE1EE1
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:11:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id t1v8Bi9kkUiJIiCC for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:11:01 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:11:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: filter out imaxpct value in test 096
Message-ID: <20090423171101.GA11391@infradead.org>
References: <49EE2664.7030701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE2664.7030701@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Apr 21, 2009 at 03:02:44PM -0500, Eric Sandeen wrote:
> xfstests: filter out imaxpct value in test 096
> 
> On large filesystems, imaxpc drops from 25 to 5
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
