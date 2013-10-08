Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 562E07F6F
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 12:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9223AC002
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 10:23:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id CBCIwN4AtstR3XSe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 10:23:53 -0700 (PDT)
Date: Tue, 8 Oct 2013 10:23:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: restrict platform_test_xfs_fd to regular files
Message-ID: <20131008172351.GA5762@infradead.org>
References: <5254221E.1000503@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5254221E.1000503@redhat.com>
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

Looks good - I just finished debugging this issue and wondered how to
fix it it best.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
