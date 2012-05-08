Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48FZrAD199684 for <xfs@oss.sgi.com>; Tue, 8 May 2012 10:35:53 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9kKKiMKB7ONRHOIS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 08:35:52 -0700 (PDT)
Date: Tue, 8 May 2012 11:35:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for April 2012
Message-ID: <20120508153551.GB8176@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

April was a relatively quite month in XFS development, partially because
most XFS developers traveled to San Francisco for the Linux Filesystem
and Storage Summit and the first XFS developers meeting co hosted at the
Linux Foundation Collaboration Summit.

The XFS development tree only saw a series to reduce ilock hold times and
a few patches merged.  Traffic on the mailing list list has been a bit more
busy, with a few patchset being reposted again and again after various
updates.  Features still scheduled for Linux 3.5 include:  removal of
the xfsbufd daemon, various other cleanups of the buffer layer, moving
CIL commits into a background thread and thus reducing the impact on
threads causing the commits, as well as a bigger than usual set of
cleanups and fixes.

The user space side as been extremely slow with no patches applied and
very few posted to the mailing list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
