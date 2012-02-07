Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17DOuKB227838 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 07:24:57 -0600
Date: Tue, 7 Feb 2012 08:24:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] better dquot caching
Message-ID: <20120207132452.GA1692@infradead.org>
References: <20120201135719.202171828@bombadil.infradead.org>
	<20120207073009.GM13095@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120207073009.GM13095@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Feb 07, 2012 at 01:30:09AM -0600, Ben Myers wrote:
> These conflict with Chandra's project quota patches.  I've started
> looking at them again, but I am a little uncomfortable with the change
> to the superblock...  could I get your opinion of that while I take a
> look at these?

Can you review patch 1 for now as that's a 3.3 candidate.  I'll rebase
the rest on top his changes later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
