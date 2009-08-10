Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AFhiXh067636 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 10:43:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EBF51D56B24
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 08:44:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Jzxvyo7rR7XskjrV for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 08:44:38 -0700 (PDT)
Date: Mon, 10 Aug 2009 11:44:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 1/2] xfstests: split out xfs & generic quota
	existence tests
Message-ID: <20090810154436.GA23666@infradead.org>
References: <4A7C7C1C.2010202@redhat.com> <4A8030F1.9060004@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A8030F1.9060004@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 10, 2009 at 09:38:41AM -0500, Eric Sandeen wrote:
> Split out xfs & generic quota existence tests
> 
> Make a new test to test for generic quota tools, for
> generic filesystem testing.  Move the existing quota test
> to a new "xfs" name.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
