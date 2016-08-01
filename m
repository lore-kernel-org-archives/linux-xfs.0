Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A8477CE0
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:30:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0C54304062
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:30:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KKH6FX1HEtVZa0ad (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:30:06 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:30:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/17] xfs/122: add the realtime rmapbt inode and btree
	fields
Message-ID: <20160801063004.GO596@infradead.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914488084.11762.2546324713817812928.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914488084.11762.2546324713817812928.stgit@birch.djwong.org>
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
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 04:48:00PM -0700, Darrick J. Wong wrote:
> Add the on-disk structures added by the realtime rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
