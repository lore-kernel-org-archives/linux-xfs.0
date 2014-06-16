Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DE377F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 04:40:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DBCFAC0B7
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 02:40:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id S5GntvkssNZwWPvH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 02:40:22 -0700 (PDT)
Date: Mon, 16 Jun 2014 02:40:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfsprogs: indicate default mount options in xfs.5
	manpage
Message-ID: <20140616094020.GC26172@infradead.org>
References: <5398B5ED.6030703@redhat.com>
 <5398B649.6020600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5398B649.6020600@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Karel Zak <kzak@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 11, 2014 at 03:04:25PM -0500, Eric Sandeen wrote:
> Not every pair of mount options indicated which was the
> default, so add those.

Looks good, but why have this separate from the previous patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
