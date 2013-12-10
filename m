Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 436FD7FB1
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 10:13:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1DA6AC00A
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 08:13:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id fZjwIEG9A4lT3t8E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 08:13:50 -0800 (PST)
Date: Tue, 10 Dec 2013 08:13:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131210161349.GD19510@infradead.org>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
	<20131208223610.GE31386@dastard>
	<20131209181612.GA22183@infradead.org>
	<20131209222433.GY10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209222433.GY10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 09:24:33AM +1100, Dave Chinner wrote:
> I wouldn't have pointed at it if the original code had that
> problem... :/

Strange.  I'd swear I haven't reworded anything.  I'll fix it back up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
