Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C79C7CD3
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F8A18F8035
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:39:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id XFmqbs3OlO77NmSJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:39:36 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:39:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 007/119] xfs: rearrange xfs_bmap_add_free parameters
Message-ID: <20160617113933.GE19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612631720.12839.5804944531874278200.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612631720.12839.5804944531874278200.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Jun 16, 2016 at 06:18:37PM -0700, Darrick J. Wong wrote:
> This is already in xfsprogs' libxfs, so port it to the kernel.

Oh well, this is something that should have gone into the kernel
at the same time..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
