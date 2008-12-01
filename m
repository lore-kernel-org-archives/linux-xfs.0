Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1NHP8B028489 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 17:17:25 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 390283041D9
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 15:17:25 -0800 (PST)
Date: Mon, 1 Dec 2008 17:22:54 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 0/9] CRC support for superblock, ag headers, log and
	btree blocks
Message-ID: <20081201232254.GA25288@sgi.com>
References: <20080925225613.GA9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225613.GA9822@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

On Fri, Sep 26, 2008 at 12:56:13AM +0200, Christoph Hellwig wrote:
| Here's an updated crc series for various metadata structures.  We're still
| looking at the magic number in the log recovery case because getting down
| a buffer type for the other structures wasn't quite as easy as for the
| btree block.  I'll probably look into that again once we're done with all
| data structures.

IIUC, this is the latest crc series, right?  
(I had once thought, perhaps mistakenly, that there would be a refreshed patchset 
subsequent to this one).

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
