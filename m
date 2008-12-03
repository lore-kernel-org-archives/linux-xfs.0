Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB36QHGF024847 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 00:26:18 -0600
Message-ID: <49362688.4030200@sgi.com>
Date: Wed, 03 Dec 2008 17:26:16 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 11/22] cleanup xfs_sb.h feature flag helpers
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.115809000@bombadil.infradead.org>
In-Reply-To: <20081202160651.115809000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

Looks ok, I think all these used to be macros, but when they got cleaned up
a lot of grogens were left in place. I wish we could get all this kind of thing
cleaned up right first time...

Reviewed-by: Donald Douwsma <donaldd@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
