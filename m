Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB9AG94i015348 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 04:16:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2BBD2807
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 02:16:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jsWBucwamlMwJC4k for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 02:16:08 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L9zdQ-0000Ml-KE
	for xfs@oss.sgi.com; Tue, 09 Dec 2008 10:16:08 +0000
Date: Tue, 9 Dec 2008 05:16:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: cleanup _rmt_dev
Message-ID: <20081209101608.GA28348@infradead.org>
References: <20081206102709.GB30364@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081206102709.GB30364@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Sat, Dec 06, 2008 at 05:27:09AM -0500, Christoph Hellwig wrote:
> Rewrite _rmt_dev to be proper ANSI C and readable.

Patch withdrawn.  I'll do a bigger one instead to give this treatment
to all of librmt.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
