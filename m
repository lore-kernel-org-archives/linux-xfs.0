Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14B2C7CA1
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 06:52:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E3A9AC001
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:52:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HbIPYLRPErVYT3XU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 04:52:06 -0700 (PDT)
Date: Thu, 12 May 2016 04:52:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: check report_mount return value
Message-ID: <20160512115204.GC32528@infradead.org>
References: <1e8b9ace-2fa3-bc11-4487-19be60053ef9@sandeen.net>
	<20160512031500.GD17859@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512031500.GD17859@dhcp12-143.nay.redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 12, 2016 at 11:15:00AM +0800, Zorro Lang wrote:
> Thanks for fix my mistake. I can add TERSE report functional
> test into my xfs/106 patch(which you're reviewing). Then it
> can find bugs likes this ASAP.

Yes, please.  Additional test coverage is always good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
