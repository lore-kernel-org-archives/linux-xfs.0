Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3A4529E05
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 11:31:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61B62AC002
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:31:40 -0800 (PST)
Received: from sabe.cs.wisc.edu (sabe.cs.wisc.edu [128.105.6.20]) by
	cuda.sgi.com with ESMTP id DCFSMBFDWui5ju1U (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:31:38 -0800 (PST)
Subject: Re: [PATCH 00/35 v4] separate operations from flags in the
	bio/request structs
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
	<20160229171339.GA17755@infradead.org>
From: Mike Christie <michaelc@cs.wisc.edu>
Message-ID: <56D4802E.3090507@cs.wisc.edu>
Date: Mon, 29 Feb 2016 11:30:22 -0600
MIME-Version: 1.0
In-Reply-To: <20160229171339.GA17755@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 02/29/2016 11:13 AM, Christoph Hellwig wrote:
> Any reason you've dropped my ACK for the previous version?

Sorry. I think I accidentally dropped it when I rebased back over to
linux-next. It looks like it only got stuck on the first patch. I will
fix that up on the resend for those kbuild errors.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
