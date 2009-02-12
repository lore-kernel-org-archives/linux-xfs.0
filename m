Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CIJEZg071055 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 12:19:14 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7D05117BBC
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:18:38 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id bD5Y3XcvtnD7K69m for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 10:18:38 -0800 (PST)
Message-ID: <49946140.6010103@sandeen.net>
Date: Thu, 12 Feb 2009 11:49:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, needs a new owner] XFS misc patches
References: <49939FDA.6090401@sgi.com>
In-Reply-To: <49939FDA.6090401@sgi.com>
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
To: Mark Goodwin <goodwinos@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> Series of 12 patches, originally by Dave Chinner. These will need
> forward porting to top-of-tree and careful review. See the description
> in each individual patch for details of each patch.
> 
> 01/12 readpage-unwritten-mapping
> 02/12 xfs-fix-log-io-latency
> 03/12 xfs-use-meta-io-for-async-metadata
> 04/12 xfs-inval-page-fixup
> 05/12 xfs-iolock-on-page-mkwrite
> 06/12 xfs-non-block-writes-when-frozen
> 07/12 xfs-non-block-setattr-size-when-frozen
> 08/12 xfs-inode-search
> 09/12 xfs-v2-inodes-default
> 10/12 xfs-inode-writeback-checking
> 11/12 xfs-inode-swap
> 12/12 xfs-increase-iclogs

Mark, thanks a lot for getting these out there.  Maybe we can get this
stuff to the wiki and track who's willing to look at them.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
