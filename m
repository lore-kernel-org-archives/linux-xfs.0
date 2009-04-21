Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LEFneL131696 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 09:15:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1495E22BE8A
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 07:15:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id p9yNjGvncvbqWayg for
	<xfs@oss.sgi.com>; Tue, 21 Apr 2009 07:15:45 -0700 (PDT)
Date: Tue, 21 Apr 2009 10:15:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] put xfs build features into the stats file
Message-ID: <20090421141545.GB26214@infradead.org>
References: <49EBDF30.90702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EBDF30.90702@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 19, 2009 at 09:34:24PM -0500, Eric Sandeen wrote:
> Running xfstests on an xfs build w/o xattrs enabled

How did you disable xattrs?

Should probably be a separate file, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
