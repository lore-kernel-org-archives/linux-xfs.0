Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7620F7F4E
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 04:08:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2193BAC002
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 02:08:09 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0KvMuOGCrcyEbos3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 02:08:08 -0800 (PST)
Date: Sun, 17 Nov 2013 02:08:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_fsr: fix SWAPEXT failures under selinux
Message-ID: <20131117100808.GB31408@infradead.org>
References: <5261B11F.1040000@redhat.com>
 <5261B67A.6000109@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5261B67A.6000109@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
