Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBM8rir8025280 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 02:53:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF1343D800
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 00:53:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KAjlMX0QsSQP4j2T for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 00:53:42 -0800 (PST)
Date: Mon, 22 Dec 2008 03:53:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and
	buffered I/O with DMAPI]
Message-ID: <20081222085311.GB24795@infradead.org>
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
	<493DFDBD.7060909@sgi.com> <20081209092240.GA23915@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081209092240.GA23915@infradead.org>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Do you need more input on this one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
