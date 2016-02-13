Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 43C9D7CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 02:02:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C49B6AC002
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 00:02:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EqGQI4PrcEiqAYry (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Feb 2016 00:02:16 -0800 (PST)
Date: Sat, 13 Feb 2016 00:02:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160213080215.GA2151@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160213023310.GC14668@dastard>
	<20160213044400.GJ6350@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160213044400.GJ6350@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2016 at 08:44:00PM -0800, Darrick J. Wong wrote:
> Brain dead, going to bed.  Next on my list is to rebase the more stable
> parts of the patchset against Dave's for-4.6 branch and do another mass
> mailing.

Yes, it would be great the prep work into for-next ASAP.  Another
important thing would be to rebase on the writepage changes now that
they are basically ready to be merged.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
