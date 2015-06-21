Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FA587F51
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:21:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0290A304051
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:21:18 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4GQW3m5wvae6En6B (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:21:17 -0700 (PDT)
Date: Sun, 21 Jun 2015 02:21:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] xfs_repair: include any realloc'ed buffers in
	final putbuf
Message-ID: <20150621092116.GD26833@infradead.org>
References: <1434726241-11606-1-git-send-email-mggr@pml.ac.uk>
	<1434726241-11606-4-git-send-email-mggr@pml.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434726241-11606-4-git-send-email-mggr@pml.ac.uk>
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
To: Mike Grant <mggr@pml.ac.uk>
Cc: xfs@oss.sgi.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
