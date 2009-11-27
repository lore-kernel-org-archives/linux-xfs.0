Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nARF7WWm147670 for <xfs@oss.sgi.com>; Fri, 27 Nov 2009 09:07:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D132A18EF4CA
	for <xfs@oss.sgi.com>; Fri, 27 Nov 2009 07:08:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FoJPvBLkPXRVFPmp for
	<xfs@oss.sgi.com>; Fri, 27 Nov 2009 07:08:00 -0800 (PST)
Date: Fri, 27 Nov 2009 10:07:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsdump debian package generation
Message-ID: <20091127150759.GA10145@infradead.org>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

Hi Nathan,

it seems like xfsdump doesn't have the hardlink based debian package
generation yet.  I was just looking at porting over all recent build
system improvement in xfsprogs and wondered if that was intentional.

If possible I'd like to keep the two build systems as close as possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
