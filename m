Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D4E57CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:07:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F4D28F804B
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:07:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UfPxKBYSJzdhksPn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:07:39 -0700 (PDT)
Date: Thu, 26 May 2016 09:07:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] tests: don't put loop control files on the scratch
	mount
Message-ID: <20160526160701.GA16512@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<146424223512.6278.15231849939938178494.stgit@birch.djwong.org>
	<20160526080948.GC20307@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160526080948.GC20307@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 26, 2016 at 01:09:48AM -0700, Christoph Hellwig wrote:
> Shouldn't these tests also add a _require_test now?  But we probably
> should just move them to /tmp instead?

Yes.  I'll move 'em to /tmp.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
